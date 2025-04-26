import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination_package/features/pagination/models/pagination_response.dart';
import 'package:infinite_scroll_pagination_package/features/pagination/pages/custom_infinite_scroll_view.dart';
import 'package:infinite_scroll_pagination_package/features/users/data/models/user_model.dart';
import 'package:infinite_scroll_pagination_package/features/users/domain/usecases/get_users_use_case.dart';
import 'package:infinite_scroll_pagination_package/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const ListViewScreen(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Infinite Scroll')),
        body: CustomInfiniteScrollView<UserModel>(
          fetchPage: (pageKey, pageSize) async {
            final result = await getIt<GetUsersUseCase>().call(pageKey);
            return result.fold(
              (failure) {
                throw Exception(failure.message);
              },
              (usersResponseModel) {
                return PaginationResponse<UserModel>(
                  items: usersResponseModel.data,
                  currentPage: usersResponseModel.pagination.currentPage,
                  totalItems: usersResponseModel.pagination.total,
                  totalPage: usersResponseModel.pagination.lastPage,
                );
              },
            );
          },
          itemBuilder: (context, item, index) {
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.email),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(item.avatar ?? ''),
              ),
            );
          },
        ),
      ),
    );
  }
}
