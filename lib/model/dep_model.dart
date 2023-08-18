class DepModel {
  String deptSn;
  String deptname;
  String wardName;
  String wardSn;

  DepModel(
      {required this.deptSn,
      required this.deptname,
      required this.wardName,
      required this.wardSn});

  factory DepModel.fromJson(Map<String, dynamic> json) {
    return DepModel(
      deptSn: json['deptSn'],
      deptname: json['deptname'],
      wardName: json['wardName'],
      wardSn: json['wardSn'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['deptSn'] = deptSn;
    data['deptname'] = deptname;
    data['wardName'] = wardName;
    data['wardSn'] = wardSn;
    return data;
  }
}
