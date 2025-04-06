import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_app/core/theme/colors/cy_color_theme.dart';
import 'package:hr_app/core/theme/typography/cy_text_theme.dart';
import 'package:hr_app/utils/resources/assets_manager.dart';
import 'package:hr_app/utils/resources/font_manager.dart';
import 'package:hr_app/utils/resources/strings.dart';
import 'package:hr_app/utils/resources/values_manager.dart';

class FilePickerWidget extends StatefulWidget {
  final Function(List<FileInfo> files) onAttachmentSelected;
  final bool allowMultiple;
  final String title;
  final List<String> allowedExtensions;

  const FilePickerWidget({
    super.key,
    required this.onAttachmentSelected,
    this.allowMultiple = false,
    required this.title,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf'],
  });

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  final List<FileInfo> _uploadedFiles = [];
  bool _isUploading = false;
  List<String> _allowedExtensions = [];

  @override
  void initState() {
    super.initState();
    _allowedExtensions = widget.allowedExtensions;
  }

  Future<String> fileToBase64(File file) async {
    try {
      List<int> fileBytes = await file.readAsBytes();
      return base64Encode(fileBytes);
    } catch (e) {
      debugPrint('Error converting file to base64: $e');
      return '';
    }
  }

  bool _isDuplicate(String fileName) => _uploadedFiles.any(
    (file) => file.name.toLowerCase() == fileName.toLowerCase(),
  );

  Future<void> _pickFile() async {
    try {
      setState(() {
        _isUploading = true;
      });

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: widget.allowMultiple,
        allowedExtensions: _allowedExtensions,
      );

      if (result == null || result.files.isEmpty) return;

      if (widget.allowMultiple) {
        List<String> duplicateFiles = [];

        for (var file in result.files) {
          if (file.path == null) continue;

          if (_isDuplicate(file.name)) {
            duplicateFiles.add(file.name);
            continue;
          }

          final mimeType = file.extension?.toLowerCase() ?? '';
          if (!_allowedExtensions
              .map((e) => e.toLowerCase())
              .contains(mimeType.toLowerCase())) {
            _showErrorMessage(
              'File ${file.name}: Unsupported format. Allowed: ${_allowedExtensions.join(", ")}',
            );
            continue;
          }

          final fileObj = File(file.path!);
          final base64String = await fileToBase64(fileObj);

          if (base64String.isNotEmpty) {
            _uploadedFiles.add(
              FileInfo(
                name: file.name,
                path: file.path!,
                mimeType: mimeType,
                base64: base64String,
              ),
            );
            setState(() {});
          }
        }

        if (duplicateFiles.isNotEmpty) {
          String message =
              duplicateFiles.length == 1
                  ? "File '${duplicateFiles[0]}' is already added."
                  : "${duplicateFiles.length} files were skipped as they are already added.";
          _showInfoMessage(message);
        }
      } else {
        final file = result.files.first;
        if (file.path == null) return;

        final mimeType = file.extension?.toLowerCase() ?? '';
        if (!_allowedExtensions
            .map((e) => e.toLowerCase())
            .contains(mimeType.toLowerCase())) {
          _showErrorMessage(
            'Unsupported file format. Allowed: ${_allowedExtensions.join(", ")}',
          );
          return;
        }

        final fileObj = File(file.path!);
        final base64String = await fileToBase64(fileObj);

        if (base64String.isNotEmpty) {
          setState(() {
            if (_uploadedFiles.isNotEmpty) {
              _uploadedFiles[0] = FileInfo(
                name: file.name,
                path: file.path!,
                mimeType: mimeType,
                base64: base64String,
              );
            } else {
              _uploadedFiles.add(
                FileInfo(
                  name: file.name,
                  path: file.path!,
                  mimeType: mimeType,
                  base64: base64String,
                ),
              );
            }
          });
        }
      }
      widget.onAttachmentSelected(_uploadedFiles);
    } catch (e) {
      _showErrorMessage('Error uploading file: ${e.toString()}');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
    widget.onAttachmentSelected(_uploadedFiles);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _getFileTypeIcon(String mimeType) {
    IconData iconData;
    Color iconColor;

    switch (mimeType.toLowerCase()) {
      case 'pdf':
        iconData = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
        iconData = Icons.image;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor, size: 20.sp);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: CyTypography.of(context).body.typoBodyMedium14,
            ),
            if (_uploadedFiles.isNotEmpty)
              Text(
                '${_uploadedFiles.length} ${_uploadedFiles.length > 1 ? 'files' : 'file'}',
                style: TextStyle(
                  color: CyColorTheme.of(context).lightText,
                  fontSize: FontSize.s14.sp,
                ),
              ),
          ],
        ),
        SizedBox(height: AppSize.s12.h),
        Container(
          padding: EdgeInsets.all(AppPadding.p12),
          decoration: BoxDecoration(
            color: CyColorTheme.of(context).white,
            border: Border.all(color: CyColorTheme.of(context).border),
            borderRadius: BorderRadius.circular(AppSize.s8.r),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Allowed: ${_allowedExtensions.join(", ")}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CyColorTheme.of(context).lightText,
                        fontSize: FontSize.s12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: CyColorTheme.of(context).secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s10.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.p16.w,
                        vertical: AppPadding.p8.h,
                      ),
                    ),
                    onPressed:
                        _isUploading
                            ? null
                            : (!widget.allowMultiple &&
                                _uploadedFiles.isNotEmpty)
                            ? () => _showReplaceConfirmation(context)
                            : _pickFile,
                    icon:
                        _isUploading
                            ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: CyColorTheme.of(context).white,
                              ),
                            )
                            : ImageIcon(
                              AssetImage(ImageAssets.upload),
                              color: CyColorTheme.of(context).white,
                              size: 16.sp,
                            ),
                    label: Text(
                      _isUploading
                          ? 'Uploading...'
                          : (!widget.allowMultiple && _uploadedFiles.isNotEmpty)
                          ? 'Replace File'
                          : uploadFile,
                      maxLines: 1,
                      style: TextStyle(
                        color: CyColorTheme.of(context).white,
                        fontSize: FontSize.s12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              if (_uploadedFiles.isNotEmpty) ...[
                SizedBox(height: AppSize.s4.h),
                Divider(color: CyColorTheme.of(context).border),
                SizedBox(height: AppSize.s6.h),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _uploadedFiles.length,
                  separatorBuilder:
                      (context, index) => SizedBox(height: AppSize.s8.h),
                  itemBuilder: (context, index) {
                    final file = _uploadedFiles[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppPadding.p12.w,
                        vertical: AppPadding.p8.h,
                      ),
                      decoration: BoxDecoration(
                        color: CyColorTheme.of(context).background,
                        borderRadius: BorderRadius.circular(AppSize.s6.r),
                      ),
                      child: Row(
                        children: [
                          _getFileTypeIcon(file.mimeType),
                          SizedBox(width: AppSize.s8.w),
                          Expanded(
                            child: Text(
                              file.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  CyTypography.of(context).body.typoBodyLight14,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeFile(index),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 18.sp,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(
                              minWidth: 24.w,
                              minHeight: 24.h,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showReplaceConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Replace File',
              style: CyTypography.of(context).headline.typoHeadlineBold16,
            ),
            content: Text(
              'Do you want to replace the existing file?',
              style: CyTypography.of(context).body.typoBodyMedium14,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Replace'),
              ),
            ],
          ),
    );

    if (result == true) {
      _pickFile();
    }
  }
}

class FileInfo {
  final String name;
  final String path;
  final String mimeType;
  final String base64;

  FileInfo({
    required this.name,
    required this.path,
    required this.mimeType,
    required this.base64,
  });
}
