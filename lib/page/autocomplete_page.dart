import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../model/diagnosis_model.dart';
import '../tool/util_method.dart';

class AutoCompletePage extends StatefulWidget {
  final List<String> searchDataList;
  final String titleText;

  const AutoCompletePage(
      {Key? key, required this.searchDataList, required this.titleText})
      : super(key: key);

  @override
  State<AutoCompletePage> createState() => _AutoCompletePageState();
}

class _AutoCompletePageState extends State<AutoCompletePage> {
  String? _selectText;
  List _diagnosisAndNameList = [];
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = Dio().get("http://36.133.207.144:56/hospatil/zy/getIcdsAll");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.titleText),
      ),
      body: Container(
        alignment: Alignment.center,
        child: widget.titleText == '选择诊断'
            ? returnDiagnosisSearchFuture()
            : returnDepSearchWidget(),
      ),
    );
  }

  List returnAllDiagnosisData(data) {
    List<DiagnosisData> resultList = [];
    List<String> diagnosisNameList = [];
    for (var value in data) {
      resultList.add(DiagnosisData.fromJson(value));
      diagnosisNameList.add(DiagnosisData.fromJson(value).name);
    }
    return [resultList, diagnosisNameList];
  }

  ///诊断走网络请求
  Widget returnDiagnosisSearchFuture() {
    return FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //请求完成
          if (snapshot.connectionState == ConnectionState.done) {
            Response response = snapshot.data;
            //发生错误
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            _diagnosisAndNameList =
                returnAllDiagnosisData(response.data['data']);

            // 请求成功，通过项目信息构建用于显示项目名称的ListView
            return Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.5, color: Colors.grey),
                    ),
                  ),
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  child: Autocomplete<String>(
                    fieldViewBuilder: ((context,
                        textEditingController,
                        focusNode,
                        onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onEditingComplete: onFieldSubmitted,
                        decoration: const InputDecoration(
                            hintText: '输入诊断（例如：上呼吸道感染）'),
                      );
                    }),
                    optionsBuilder: (TextEditingValue value) {
                      // When the field is empty
                      if (value.text.isEmpty) {
                        return [];
                      }
                      return ((_diagnosisAndNameList[1] as List<String>).where(
                          (String suggestion) =>
                              suggestion.contains(value.text)));
                    },
                    onSelected: (value) {
                      setState(() {
                        _selectText = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () {
                      if (_diagnosisAndNameList[1]
                          .any((element) => element == _selectText)) {
                        String code = _diagnosisAndNameList[0][
                                _diagnosisAndNameList[1].indexWhere(
                                    (element) => element == _selectText)]
                            .code;
                        Navigator.pop(context, '${_selectText!}=$code');
                      } else {
                        UtilMethod().showConfirmDialog('诊断选择错误！', context);
                      }
                    },
                    style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Color.fromARGB(0, 129, 216, 207))),
                    child: const Text('提交'))
              ],
            );
          }
          //请求未完成时弹出loading
          return const CircularProgressIndicator();
        });
  }

  ///科别
  Widget returnDepSearchWidget() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.grey),
            ),
          ),
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: Autocomplete<String>(
            fieldViewBuilder: ((context,
                textEditingController,
                focusNode,
                onFieldSubmitted) {
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                onEditingComplete: onFieldSubmitted,
                decoration: const InputDecoration(
                    hintText: '输入入院科别（例如：心血管内科病房）'),
              );
            }),
            optionsBuilder: (TextEditingValue value) {
              // When the field is empty
              if (value.text.isEmpty) {
                return [];
              }
              return (( widget.searchDataList).where(
                      (String suggestion) =>
                      suggestion.contains(value.text)));
            },
            onSelected: (value) {
              setState(() {
                _selectText = value;
              });
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextButton(
            onPressed: () {
              if (widget.searchDataList
                  .any((element) => element == _selectText)) {
                Navigator.pop(context, _selectText);
              } else {
                UtilMethod().showConfirmDialog('科别选择错误！', context);
              }
            },
            style: const ButtonStyle(
                backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(0, 129, 216, 207))),
            child: const Text('提交'))
      ],
    );
  }
}
