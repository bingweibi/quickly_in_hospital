import 'package:flutter/material.dart';
import '../tool/util_method.dart';
import 'model/doctor_model.dart';
import 'page/apply_page.dart';
import 'data/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '便捷入院',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(100, 129, 216, 207)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: '电子入院申请'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _uNameController = TextEditingController();
  final TextEditingController _uIDController = TextEditingController();
  List<DoctorsModel> allDoctors = [];
  late DoctorsModel loginDoctor;

  @override
  void initState() {
    for (var element in Data.doctorData) {
      allDoctors.add(DoctorsModel.fromJson(element));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              decoration:  BoxDecoration(
                boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 20.0)],
                color: Colors.white,
                borderRadius: BorderRadius.circular((20.0)),
              ),
              child:  Column(children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  child: TextField(
                    autofocus: true,
                    controller: _uNameController,
                    decoration: const InputDecoration(
                        labelText: '姓名',
                        hintText: '输入医师姓名',
                        prefixIcon: Icon(Icons.account_circle)),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _uIDController,
                    decoration: const InputDecoration(
                        labelText: '工号',
                        hintText:'输入医师工号',
                        prefixIcon: Icon(Icons.person)),
                  ),
                ),
              ],
            )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: TextButton(
                  onPressed: () {
                    if (validatorInput(_uNameController.text+_uIDController.text)) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ApplyPage(loginDoctor: loginDoctor);
                      }));
                    } else {
                      UtilMethod().showConfirmDialog("输入的姓名或工号有误！请重新输入", context);
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color.fromARGB(100, 129, 216, 207))),
                  child: const Text('登录')),
            ),
          ],
        ),
      ),
    );
  }

  bool validatorInput(String text) {
    for (var value in allDoctors) {
      if(value.name + value.empSn == text){
        loginDoctor = DoctorsModel(empSn: value.empSn, name: value.name);
        return true;
      }
    }
    return false;
  }
}
