import 'package:flutter/material.dart';
import 'package:machintest/repository.dart';

import 'package:machintest/track_online_users.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Datum> userdata = [];
  bool dataLoadingFirstTime = true;
  bool moredataLoading = false;
  String? nextLink = 'https://gorest.co.in/public/v1/users';

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  fetchApi() async {
    setState(() {
      moredataLoading = true;
    });
    TrackOnlineUsers trackOnlineUsers = await Repo().fetchApi(nextLink!);
    userdata.addAll(trackOnlineUsers.data);
    setState(() {
      nextLink = trackOnlineUsers.meta.pagination.links.next;
      dataLoadingFirstTime = false;
      moredataLoading = false;
    });
  }

  loadmore() {
    if (nextLink != null) {
      fetchApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('machine test'),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: const Text('users which are active'),
            ),
            if (!dataLoadingFirstTime && userdata.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: userdata.length,
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: const EdgeInsets.all(20),
                            height: 50,
                            width: double.infinity,
                            child: Column(
                              children: [Text(userdata[index].name)],
                            ),
                          );
                        }),
                      ),
                    ),
                    if (nextLink != null)
                      Container(
                        height: 45,
                        width: double.infinity,
                        child: moredataLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : TextButton(
                                onPressed: () {
                                  loadmore();
                                },
                                child: const Text('Load More'),
                              ),
                      )
                  ],
                ),
              ),
            if (!dataLoadingFirstTime && userdata.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No data'),
                ),
              ),
            if (dataLoadingFirstTime)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
