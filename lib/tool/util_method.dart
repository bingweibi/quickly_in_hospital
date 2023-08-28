import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/locations_data.dart';
import '../data/data.dart';
import '../model/dep_model.dart';
import '../model/updata_model.dart';

class UtilMethod {
  /// 校验身份证合法性
  String verifyCardId(String cardId) {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    String tip = '';
    bool pass = true;

    RegExp cardReg = RegExp(
        r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if (cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      tip = '身份证号格式错误';
      pass = false;
      return '$pass-$tip';
    }
    if (city[int.parse(cardId.substring(0, 2))] == null) {
      tip = '地址编码错误';
      pass = false;
      return '$pass-$tip';
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      var last = parity[sum % 11];
      if (parity[sum % 11].toString() != numList[17]) {
        tip = "校验位错误";
        return '$pass-$tip';
      }
    } else {
      tip = '身份证号不是18位';
      pass = false;
    }
//  print('证件格式$pass');
    return '$pass-$tip';
  }

  /// 根据身份证号获取年龄
  String getAgeFromCardId(String cardId) {
    int len = (cardId).length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday =
          "${cardId.substring(6, 10)}-${cardId.substring(10, 12)}-${cardId.substring(12, 14)}";
    }
    if (len == 15) {
      strBirthday =
          "19${cardId.substring(6, 8)}-${cardId.substring(8, 10)}-${cardId.substring(10, 12)}";
    }
    int age = getAgeFromBirthday(strBirthday);
    return '$strBirthday+$age';
  }

  /// 根据出生日期获取年龄
  int getAgeFromBirthday(String strBirthday) {
    if (strBirthday.isEmpty) {
      print('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  /// 根据身份证获取性别
  String getSexFromCardId(String cardId) {
    String sex = "";
    if (cardId.length == 18) {
      if (int.parse(cardId.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    if (cardId.length == 15) {
      if (int.parse(cardId.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }

  ///检查输入的电话
  bool verifyTel(String tel) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(tel);
  }

  /// 弹出对话框
  Future<bool?> showConfirmDialog(String tipText, BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("提示"),
          content: Text(tipText),
          actions: <Widget>[
            TextButton(
              child: const Text("确定"),
              onPressed: () => Navigator.of(context).pop(), //关闭对话框
            )
          ],
        );
      },
    );
  }

  /// 拼接城市
  String spliceCityName({String? pName, String? cName, String? tName}) {
    if (strEmpty(pName)) return '不限';
    StringBuffer sb = StringBuffer();
    sb.write(pName);
    if (strEmpty(cName)) return sb.toString();
    sb.write(' - ');
    sb.write(cName);
    if (strEmpty(tName)) return sb.toString();
    sb.write(' - ');
    sb.write(tName);
    return sb.toString();
  }

  /// 字符串为空
  bool strEmpty(String? value) {
    if (value == null) return true;
    return value.trim().isEmpty;
  }

  ///病情转化
  String situationCast(String type) {
    if (type == '危') {
      return '1';
    } else if (type == '急') {
      return '2';
    } else if (type == '一般') {
      return '3';
    }
    return '1';
  }

  /// 城市转化code
  String cityCodeCast(String provinceName, String cityName, String townName) {
    List<String> cityCode = Address.getCityCodeByName(
        provinceName: provinceName, cityName: cityName, townName: townName);
    return cityCode.last;
  }

  ///入科科别
  String admissWardAndDeptPlanCast(String selectDep) {
    for (var element in Data.depData) {
      if (selectDep == DepModel.fromJson(element).wardName) {
        return '${DepModel.fromJson(element).wardSn}-${DepModel.fromJson(element).deptSn}';
      }
    }
    return '1020106';
  }

  /// 验证上传数据
  Future<bool> verifyUpData(UpDataModel? upDataModel, BuildContext context) async{
    if (upDataModel!.name.isEmpty) {
      showConfirmDialog('患者姓名格式错误 ${upDataModel.name}！', context);
      return false;
    } else if (verifyCardId(upDataModel.socialNo).split('-')[0] != 'true') {
      showConfirmDialog('身份证格式错误！', context);
      return false;
    } else if (!verifyTel(upDataModel.homeTel)) {
      showConfirmDialog('患者电话格式错误！', context);
      return false;
    } else if (upDataModel.homeStreet.isEmpty) {
      showConfirmDialog('患者详细住址格式错误！', context);
      return false;
    } else if (upDataModel.clinicDiagStr == 'null') {
      showConfirmDialog('诊断选择错误！', context);
      return false;
    } else if (!verifyTel(upDataModel.doctorPhone)) {
      showConfirmDialog('医生电话格式错误！', context);
      return false;
    }
    var response = await Dio().post('http://36.133.207.144:56/hospatil/zy/addHospital', data: {
      "admissPhysician": upDataModel.admissPhysician,
      "birthday": upDataModel.birthday,
      "clinicDiag": upDataModel.clinicDiag,
      "clinicDiagStr": upDataModel.clinicDiagStr,
      "admissDeptPlan": upDataModel.admissDeptPlan,
      "homeStreet": upDataModel.homeStreet,
      "doctorPhone": upDataModel.doctorPhone,
      "homeTel": upDataModel.homeTel,
      "name": upDataModel.name,
      "sex": upDataModel.sex,
      "socialNo": upDataModel.socialNo,
      "admissType": upDataModel.admissType,
      "admissWardPlan": upDataModel.admissWardPlan,
      "homeDistrict": upDataModel.homeDistrict,
    },);
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}
