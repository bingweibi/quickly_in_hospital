class DiagnosisModel {
    List<DiagnosisData> data;
    int code;
    String msg;

    DiagnosisModel({required this.data,required this.code,required this.msg});

    factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
        return DiagnosisModel(
            data: json['data']  (json['data'] as List).map((i) => DiagnosisData.fromJson(i)).toList(),
            code: json['code'],
            msg: json['msg'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['code'] = code;
        data['msg'] = msg;
          data['data'] = this.data.map((v) => v.toJson()).toList();
        return data;
    }
}

class DiagnosisData {
    String code;
    String id;
    String name;

    DiagnosisData({required this.code, required this.id,required this.name});

    factory DiagnosisData.fromJson(Map<String, dynamic> json) {
        return DiagnosisData(
            code: json['code'],
            id: json['id'],
            name: json['name'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['code'] = code;
        data['id'] = id;
        data['name'] = name;
        return data;
    }
}