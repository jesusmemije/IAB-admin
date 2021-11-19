// To parse this JSON data, do
//
//     final typeGuestModel = typeGuestModelFromJson(jsonString);

import 'dart:convert';

TypeGuestModel typeGuestModelFromJson(String str) => TypeGuestModel.fromJson(json.decode(str));

String typeGuestModelToJson(TypeGuestModel data) => json.encode(data.toJson());

class TypeGuestModel {
    TypeGuestModel({
        this.tipoInvitado = "",
        required this.idTipoInvitado,
    });

    String tipoInvitado;
    int idTipoInvitado;

    factory TypeGuestModel.fromJson(Map<String, dynamic> json) => TypeGuestModel(
        tipoInvitado: json["tipoInvitado"],
        idTipoInvitado: json["idTipoInvitado"],
    );

    Map<String, dynamic> toJson() => {
        "tipoInvitado": tipoInvitado,
        "idTipoInvitado": idTipoInvitado,
    };
}
