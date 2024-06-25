import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class FirebaseUtils {
  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(T Function(Map<String, dynamic> json) fromJson) {
    return StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<T>>.fromHandlers(
      handleData: (QuerySnapshot<Map<String, dynamic>> snapshot,
          EventSink<List<T>> sink) {
        final snaps = snapshot.docs.map((doc) => doc.data()).toList();
        final data = snaps.map((json) => fromJson(json)).toList();
        sink.add(data);
      },
    );
  }

  static DateTime? toDateTime(Timestamp? value) {
    if (value == null) return null;
    return value.toDate();
  }

  static DateTime? fromDateTimeToJson(DateTime? date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static Future<bool> sendFcmMessage({
    required String title,
    required String message,
    required String fcm,
    required String clickAction,
    Map<String, String>? sendData,
  }) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAA_s76W2k:APA91bFtbazHGx6uvGrFQtLU-KYl5Tl2b4QEsdTaN1IdyUzLZ516586eqwNLIlrD_QmLzDx2Q-JT7WOsIQP7E6BflyCuEqkwmjBaoAEMbyNeA5bnFY5wLpQCy0wrdzvy9GCcw_gfipEK",
      };
      var request = {
        "to": fcm,
        // "to": "/topics/all",
        "priority": "high",
        "notification": {
          "title": title,
          "body": message,
        },
        "data": {
          "clickAction": clickAction,
          "sendData": sendData,
        },
      };

      var client = Client();
      var response = await client.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(request),
      );
      if (response.statusCode == 200) {
        debugPrint('push CFM');
        return true;
      } else {
        debugPrint('CFM error');
        debugPrint(response.statusCode.toString());
        return false;
      }
    } catch (e, s) {
      debugPrint(e.toString());
      return false;
    }
  }

  static void deleteItemWithUrl(String url) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
  }

  static Future<void> deleteFolder(String folderPath) async {
    final Reference folderReference =
        FirebaseStorage.instance.ref().child(folderPath);

    // List all items (files and sub-folders) in the folder
    final ListResult listResult = await folderReference.listAll();

    // Recursively delete all files
    for (final Reference fileRef in listResult.items) {
      await fileRef.delete();
    }

    // Recursively delete all sub-folders
    for (final Reference subFolder in listResult.prefixes) {
      await deleteFolder(subFolder.fullPath);
    }

    // Finally delete the folder itself if it's empty
    await folderReference.delete();
  }
}

class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}

class GeoPointConverter implements JsonConverter<LatLng, GeoPoint> {
  const GeoPointConverter();

  @override
  LatLng fromJson(GeoPoint geoPoint) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  @override
  GeoPoint toJson(LatLng latLng) {
    return GeoPoint(latLng.latitude, latLng.longitude);
  }
}
