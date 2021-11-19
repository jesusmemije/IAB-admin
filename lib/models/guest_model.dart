// To parse this JSON data, do
//
//     final guestModel = guestModelFromJson(jsonString);

import 'dart:convert';

GuestModel guestModelFromJson(String str) => GuestModel.fromJson(json.decode(str));

String guestModelToJson(GuestModel data) => json.encode(data.toJson());

class GuestModel {
  
    GuestModel({
        required this.idInvitado,
        this.idNovios = 0,
        this.apodo    = "",
        this.nombre   = "",
        this.aPaterno = "",
        this.aMaterno = "",
        this.mesa     = 0,
        this.boletos  = 0,
        this.idTipoInvitado = 0,
        this.asistioBoda    = 0,
    });

    int idInvitado;
    int idNovios;
    String apodo;
    String nombre;
    String aPaterno;
    String aMaterno;
    int mesa;
    int boletos;
    int idTipoInvitado;
    int asistioBoda;

    factory GuestModel.fromJson(Map<String, dynamic> json) => GuestModel(
        idInvitado : json["idInvitado"],
        idNovios : json["idNovios"],
        apodo    : json["apodo"],
        nombre   : json["nombre"],
        aPaterno : json["aPaterno"],
        aMaterno : json["aMaterno"],
        mesa     : json["mesa"],
        boletos  : json["boletos"],
        idTipoInvitado : json["idTipoInvitado"],
        asistioBoda    : json["asistioBoda"]
    );

    Map<String, dynamic> toJson() => {
        "idInvitado" : idInvitado,
        "idNovios" : idNovios,
        "apodo"    : apodo,
        "nombre"   : nombre,
        "aPaterno" : aPaterno,
        "aMaterno" : aMaterno,
        "mesa"     : mesa,
        "boletos"  : boletos,
        "idTipoInvitado" : idTipoInvitado,
        "asistioBoda"    : asistioBoda
    };
}
