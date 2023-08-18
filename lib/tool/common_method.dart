
class CommonMethod{

  /// 根据身份证计算年龄
  String getSexFromIDNumber(String idNumber) {
    return int.parse(idNumber.substring(16, 17)) % 2 == 0 ? '女' : '男';
  }

  String? getAgeFromIDNumber(String idNumber) {
    String birthday =
        '${idNumber.substring(6, 10)}-${idNumber.substring(10, 12)}-${idNumber.substring(12, 14)}';
    DateTime birth = DateTime.parse(birthday);
    DateTime now = DateTime.now();
    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age.toString();
  }

  ///城市码和城市名互换
  /// 根据城市名 查询城市code(有先后顺序)
  // List<String> cityCode =  Address.getCityCodeByName(provinceName:'四川省', cityName: '成都市', townName: '武侯区');
  // return [510000,510100,510104]  or  [510000,510000]  or [510000]  or  []


  /// 通过城市code 查询城市名(有先后顺序)
  // List<String> cityName =  Address.getCityNameByCode(provinceCode: "510000", cityCode: "510100", townCode: "510104");
  // return [四川省, 成都市, 锦江区]  or  [四川省, 成都市]  or [四川省] or []

}