import 'package:flutter/material.dart';
import 'package:flutter_pickers/more_pickers/init_data.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:marquee/marquee.dart';
import '../data/data.dart';
import '../model/dep_model.dart';
import '../model/doctor_model.dart';
import '../model/updata_model.dart';
import '../tool/my_text.dart';
import '../tool/util_method.dart';
import 'autocomplete_page.dart';

class ApplyPage extends StatefulWidget {
  final DoctorsModel loginDoctor;

  const ApplyPage({Key? key, required this.loginDoctor}) : super(key: key);

  @override
  State<ApplyPage> createState() => _ApplyPageState();
}

class _ApplyPageState extends State<ApplyPage> {
  // 所在区域  省 市 区
  String initProvince = '四川省', initCity = '自贡市', initTown = '自流井区';
  String? selectName = '点击输入患者姓名';
  String selectIDNumber = '点击输入病人身份证';
  String? selectTel = '点击输入患者电话';
  String selectAddress = '四川省自贡市自流井区';
  String selectAddressDetail = '';
  List diagnosisList = ['腹痛', '头痛'];
  String selectDiagnosis = '点击填写诊断';
  String selectDiagnosisCode = '1';
  String selectSituation = '常规';
  String selectDep = '点击填写入科科别';
  List<String> wardNameList = [];
  String? doctorTel = '点击输入你的电话';
  DoctorsModel? loginDoctor;
  UpDataModel? upDataModel;
  List<String> diagnosisList1 = [];

  final TextEditingController unameController = TextEditingController();
  final TextEditingController uIDCardController = TextEditingController();
  final TextEditingController uTelController = TextEditingController();
  final TextEditingController uDocTelController = TextEditingController();
  final TextEditingController uAddressController = TextEditingController();

  final divider = const Divider(height: 1, indent: 20);
  final rightIcon = const Icon(Icons.keyboard_arrow_right);

  @override
  void initState() {
    loginDoctor = widget.loginDoctor;
    for (var element in Data.depData) {
      wardNameList.add(DepModel.fromJson(element).wardName);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('电子住院申请单'),
        ),
        body: ListView(
            children: [
              Container(
                  color: Colors.redAccent,
                  height: 20,
                  child: Marquee(text: '下列均为必填项，请保证信息填写的正确性        ')),
              Container(
                margin: const EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 20.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular((20.0)),
                  ),
                  child: Column(
                    children: [
                      _item(
                          '患者姓名', PickerDataType.education, selectName, 2,
                          customType: 'patientName'),
                      _item('身份证号', PickerDataType.zodiac, selectIDNumber,
                          2,
                          customType: 'idNumber'),
                      _item('患者电话', PickerDataType.constellation,
                          selectTel, 2,
                          customType: 'patientTel'),
                      _item('患者所在地区', PickerDataType.ethnicity,
                          selectAddress, 1,
                          customType: 'address'),
                      _item('详细地址', PickerDataType.ethnicity,
                          selectAddressDetail, 2,
                          customType: 'addressDetail'),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.grey, blurRadius: 20.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular((20.0)),
                  ),
                  child: Column(children: [
                    _item('入院诊断', diagnosisList, selectDiagnosis, 1,
                        customType: 'diagnosis'),
                    _item('入院病情', Data.situationList, selectSituation, 1,
                        customType: 'situation'),
                    _item('入科科别', wardNameList, selectDep, 1,
                        customType: 'dep'),
                  ])),
              Container(
                margin: const EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.grey, blurRadius: 20.0)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular((20.0)),
                ),
                child: _item('医生电话', PickerDataType.sex, doctorTel, 2,
                    customType: 'doctorTel'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0,bottom: 15),
                child: TextButton(
                    onPressed: () async {
                      upDataModel = UpDataModel(
                        //工号
                        loginDoctor!.empSn,
                        //生日
                        '${UtilMethod().getAgeFromCardId(uIDCardController.text).split('+')[0]} 00:00:00',
                        //诊断编码
                        selectDiagnosisCode,
                        //诊断
                        selectDiagnosis,
                        //科室编码
                        UtilMethod()
                            .admissWardAndDeptPlanCast(selectDep)
                            .split('-')[1],
                        //街道或小区
                        uAddressController.text,
                        //病人所在地区编码
                        UtilMethod().cityCodeCast(
                            initProvince, initCity, initTown),
                        //医生电话
                        uDocTelController.text,
                        //病人电话
                        uTelController.text,
                        //姓名
                        unameController.text,
                        //性别
                        UtilMethod().getSexFromCardId(
                            uIDCardController.text) ==
                            '男'
                            ? 1
                            : 2,
                        //身份证号
                        uIDCardController.text,
                        //病情
                        UtilMethod().situationCast(selectSituation),
                        //病区编码
                        UtilMethod()
                            .admissWardAndDeptPlanCast(selectDep)
                            .split('-')[0],
                      );
                      await UtilMethod()
                          .verifyUpData(upDataModel, context)
                          .then((value) {
                        if (value) {
                          UtilMethod().showConfirmDialog(
                              '入院凭证已申请成功，等待入院登记处（短号：6888）办理成功后短信通知医生和病人！',
                              context);
                          unameController.clear();
                          uIDCardController.clear();
                          uTelController.clear();
                          uDocTelController.clear();
                          uAddressController.clear();
                        } else {
                          UtilMethod()
                              .showConfirmDialog('服务器异常，请稍后再试', context);
                        }
                      });
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(100, 129, 216, 207))),
                    child: const Text('申请住院凭证')),
              )
            ]));
  }

  @override
  void dispose() {
    unameController.dispose();
    uIDCardController.dispose();
    uTelController.dispose();
    uDocTelController.dispose();
    uAddressController.dispose();
    super.dispose();
  }

  Widget _item(title, var data, var selectData, num type,
      {String? customType}) {
    return Column(
      children: [
        Container(
          height: 60,
          color: Colors.white,
          child: ListTile(
            title: Text(title),
            onTap: () => type == 2
                ? {}
                : _onClickItem(data, selectData, type, context,
                    customType: customType),
            trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  customType == 'address'
                      ? _checkLocation()
                      : (type == 2
                          ? _typeInfo(customType)
                          : Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width / 2,
                              child: MyText(
                                selectData.toString(),
                                color: Colors.grey,
                                rightpadding: 18,
                                maxLines: 2,
                              ),
                            )),
                  type == 1 && customType != 'address'
                      ? rightIcon
                      : const SizedBox(
                          width: 1,
                          height: 1,
                        )
                ]),
          ),
        ),
        divider,
      ],
    );
  }

  Future<void> _onClickItem(
      var data, var selectData, num type, BuildContext context,
      {String? customType}) async {
    if (customType == 'address') {
      _checkLocation();
    } else if (customType == 'diagnosis') {
      String returnText =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AutoCompletePage(
                  searchDataList: [],
                  titleText: '选择诊断',
                );
              })) ??
              'null=null';
      //判断诊断是否为null
      selectDiagnosis = returnText.split('=')[0];
      selectDiagnosisCode = returnText.split('=')[1];
      setState(() {});
      //_typeDiagnosis();
    } else if (customType == 'dep') {
      selectDep =
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AutoCompletePage(
                  searchDataList: wardNameList,
                  titleText: '选择科别',
                );
              })) ??
              'null';
      setState(() {});
      //_typeDiagnosis();
    } else {
      Pickers.showSinglePicker(
        context,
        data: data,
        selectData: selectData,
        pickerStyle: DefaultPickerStyle(),
        onConfirm: (p, position) {
          setState(() {
            if (customType == 'diagnosis') {
              diagnosisList[0] = p;
            } else if (customType == 'situation') {
              selectSituation = p;
            } else if (customType == 'dep') {
              selectDep = p;
            }
          });
        },
      );
    }
  }

  Widget _checkLocation() {
    Widget textView = Text(UtilMethod()
        .spliceCityName(pName: initProvince, cName: initCity, tName: initTown));

    return InkWell(
      onTap: () {
        Pickers.showAddressPicker(
          context,
          addAllItem: false,
          initProvince: initProvince,
          initCity: initCity,
          initTown: initTown,
          onConfirm: (p, c, t) {
            setState(() {
              initProvince = p;
              initCity = c;
              initTown = t ?? '';
            });
          },
        );
      },
      child: _outsideView(textView, initProvince, initCity, initTown),
    );
  }

  Widget _outsideView(Widget textView, initProvince, initCity, initTown) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textView,
          const SizedBox(width: 8),
          (initProvince != '')
              ? InkWell(
                  child: Icon(Icons.close, size: 20, color: Colors.grey[500]),
                  onTap: () {
                    setState(() {
                      initProvince = '';
                      initCity = '';
                      initTown = '';
                    });
                  })
              : const SizedBox(),
          const SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, size: 28, color: Colors.grey[500]),
        ],
      ),
    );
  }

  /// textField输入框
  Widget _typeInfo(String? customType) {
    return Container(
      alignment: Alignment.centerRight,
      width: 250,
      height: 40,
      padding: const EdgeInsets.only(left: 10),
      child: TextField(
        decoration: InputDecoration(
          hintStyle: (const TextStyle(color: Colors.grey)),
            hintText: customType == 'addressDetail'
                ? '精确到街道、小区'
                : (customType == 'patientTel' || customType == 'doctorTel'
                    ? '填写11位手机号码'
                    : '')),
        textAlign: TextAlign.end,
        keyboardType:
            (customType == 'patientName' || customType == 'addressDetail'|| customType =='idNumber')
                ? TextInputType.text
                : TextInputType.number,
        controller: customType == 'patientName'
            ? unameController
            : (customType == 'idNumber'
                ? uIDCardController
                : (customType == 'patientTel'
                    ? uTelController
                    : (customType == 'doctorTel'
                        ? uDocTelController
                        : uAddressController))),
      ),
    );
  }
}
