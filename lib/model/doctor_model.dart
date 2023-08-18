class DoctorsModel {
    String empSn;
    String name;

    DoctorsModel({required this.empSn, required this.name});

    factory DoctorsModel.fromJson(Map<String, dynamic> json) {
        return DoctorsModel(
            empSn: json['empSn'],
            name: json['name'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['empSn'] = empSn;
        data['name'] = name;
        return data;
    }
}