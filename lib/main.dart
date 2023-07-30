import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '天氣預報APP'),
    );
  }
}

class DataNotifier extends StateNotifier<Map<String, dynamic>> {
  DataNotifier() : super({'locationName': ''});


  final Dio _dio = Dio();

  Future<void> fetchData(String locationName) async {
    try {
      Response response = await _dio.get('https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001?Authorization=CWB-842AA25E-BE34-4D2F-8430-664D605A1A00&locationName=$locationName');
      List<dynamic> locations = response.data['records']['location'];
      if (locations.isEmpty || locationName=='') {
        throw RangeError('locations list is empty');
      }
      state = locations[0];
    } catch (e) {
      state = {'locationName': '回傳格式不正確或未輸入城市'};
    }
  }
}


final dataProvider = StateNotifierProvider<DataNotifier, Map<String, dynamic>>((ref) => DataNotifier());


class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _locationName = '';
    Map<String, dynamic> data = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _locationName = value;
                    },
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text('確認'),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        )
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)),
                  ),
                  onPressed: () => ref.read(dataProvider.notifier).fetchData(_locationName),
                )
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      if (data.containsKey('locationName'))
                        Text(data['locationName']),
                      Container(
                        child: Column(
                          children: [
                            if (data.containsKey('weatherElement'))
                              Text(data['weatherElement'][0]['time'][0]['startTime'] +' 至 ' +data['weatherElement'][0]['time'][0]['endTime']),
                            if (data.containsKey('weatherElement'))
                              Text('天氣現象:'+data['weatherElement'][0]['time'][0]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('降雨機率:'+data['weatherElement'][1]['time'][0]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('最低溫度:'+data['weatherElement'][2]['time'][0]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('最高溫度:'+data['weatherElement'][4]['time'][0]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('舒適度:'+data['weatherElement'][3]['time'][0]['parameter']['parameterName']),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            if (data.containsKey('weatherElement'))
                              Text(data['weatherElement'][0]['time'][1]['startTime'] +' 至 ' +data['weatherElement'][0]['time'][1]['endTime']),
                            if (data.containsKey('weatherElement'))
                              Text('天氣現象:'+data['weatherElement'][0]['time'][1]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('降雨機率:'+data['weatherElement'][1]['time'][1]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('最低溫度:'+data['weatherElement'][2]['time'][1]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('最高溫度:'+data['weatherElement'][4]['time'][1]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('舒適度:'+data['weatherElement'][3]['time'][1]['parameter']['parameterName']),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            if (data.containsKey('weatherElement'))
                              Text(data['weatherElement'][0]['time'][2]['startTime'] +' 至 ' +data['weatherElement'][0]['time'][2]['endTime']),
                            if (data.containsKey('weatherElement'))
                              Text('天氣現象:'+data['weatherElement'][0]['time'][2]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('降雨機率:'+data['weatherElement'][1]['time'][2]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('最低溫度:'+data['weatherElement'][2]['time'][2]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('最高溫度:'+data['weatherElement'][4]['time'][2]['parameter']['parameterName']),
                            if (data.containsKey('weatherElement'))
                              Text('舒適度:'+data['weatherElement'][3]['time'][2]['parameter']['parameterName']),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}