// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData()
  ..id = json['id'] as String?
  ..pseudo = json['pseudo'] as String?
  ..oneIgnalUserid = json['oneIgnalUserid'] as String?
  ..userabonnements = (json['userabonnements'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..nom = json['nom'] as String?
  ..prenom = json['prenom'] as String?
  ..telephone = json['telephone'] as String?
  ..urlImage = json['urlImage'] as String?
  ..isVerify = json['isVerify'] as bool?
  ..solde = (json['solde'] as num?)?.toInt()
  ..note = (json['note'] as num?)?.toDouble()
  ..adresse = json['adresse'] as String?
  ..email = json['email'] as String?
  ..genre = json['genre'] as String?
  ..codeParrainage = json['codeParrainage'] as String?
  ..codeParrain = json['codeParrain'] as String?
  ..role = json['role'] as String?;

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'pseudo': instance.pseudo,
      'oneIgnalUserid': instance.oneIgnalUserid,
      'userabonnements': instance.userabonnements,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'telephone': instance.telephone,
      'urlImage': instance.urlImage,
      'isVerify': instance.isVerify,
      'solde': instance.solde,
      'note': instance.note,
      'adresse': instance.adresse,
      'email': instance.email,
      'genre': instance.genre,
      'codeParrainage': instance.codeParrainage,
      'codeParrain': instance.codeParrain,
      'role': instance.role,
    };

AppDefaultData _$AppDefaultDataFromJson(Map<String, dynamic> json) =>
    AppDefaultData()
      ..id = json['id'] as String?
      ..app_link = json['app_link'] as String?
      ..app_version = (json['app_version'] as num).toInt()
      ..app_logo = json['app_logo'] as String
      ..one_signal_api_key = json['one_signal_api_key'] as String
      ..one_signal_app_id = json['one_signal_app_id'] as String
      ..one_signal_app_url = json['one_signal_app_url'] as String;

Map<String, dynamic> _$AppDefaultDataToJson(AppDefaultData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'app_link': instance.app_link,
      'app_version': instance.app_version,
      'app_logo': instance.app_logo,
      'one_signal_api_key': instance.one_signal_api_key,
      'one_signal_app_id': instance.one_signal_app_id,
      'one_signal_app_url': instance.one_signal_app_url,
    };

EventData _$EventDataFromJson(Map<String, dynamic> json) => EventData()
  ..id = json['id'] as String?
  ..userId = json['userId'] as String?
  ..titre = json['titre'] as String?
  ..description = json['description'] as String?
  ..statut = json['statut'] as String?
  ..idCategorie = json['idCategorie'] as String?
  ..categorie = json['categorie'] as String?
  ..idSousCategorie = json['idSousCategorie'] as String?
  ..sousCategorie = json['sousCategorie'] as String?
  ..typeJeu = json['typeJeu'] as String?
  ..urlPosition = json['urlPosition'] as String?
  ..longitude = (json['longitude'] as num?)?.toDouble()
  ..latitude = (json['latitude'] as num?)?.toDouble()
  ..pays = json['pays'] as String?
  ..ville = json['ville'] as String?
  ..adresse = json['adresse'] as String?
  ..userslikes =
      (json['userslikes'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..usersVues =
      (json['usersVues'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..vue = (json['vue'] as num?)?.toInt()
  ..like = (json['like'] as num?)?.toInt()
  ..partage = (json['partage'] as num?)?.toInt()
  ..commentaire = (json['commentaire'] as num?)?.toInt()
  ..createdAt = (json['createdAt'] as num?)?.toInt()
  ..updatedAt = (json['updatedAt'] as num?)?.toInt()
  ..nombreJourAvantDisparition =
      (json['nombreJourAvantDisparition'] as num?)?.toInt()
  ..date = (json['date'] as num?)?.toInt()
  ..medias = (json['medias'] as List<dynamic>)
      .map((e) => Map<String, String?>.from(e as Map))
      .toList()
  ..urlMedia = json['urlMedia'] as String?
  ..typeMedia = json['typeMedia'] as String?;

Map<String, dynamic> _$EventDataToJson(EventData instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'titre': instance.titre,
      'description': instance.description,
      'statut': instance.statut,
      'idCategorie': instance.idCategorie,
      'categorie': instance.categorie,
      'idSousCategorie': instance.idSousCategorie,
      'sousCategorie': instance.sousCategorie,
      'typeJeu': instance.typeJeu,
      'urlPosition': instance.urlPosition,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'pays': instance.pays,
      'ville': instance.ville,
      'adresse': instance.adresse,
      'userslikes': instance.userslikes,
      'usersVues': instance.usersVues,
      'vue': instance.vue,
      'like': instance.like,
      'partage': instance.partage,
      'commentaire': instance.commentaire,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'nombreJourAvantDisparition': instance.nombreJourAvantDisparition,
      'date': instance.date,
      'medias': instance.medias,
      'urlMedia': instance.urlMedia,
      'typeMedia': instance.typeMedia,
    };

CategorieEvent _$CategorieEventFromJson(Map<String, dynamic> json) =>
    CategorieEvent()
      ..id = json['id'] as String?
      ..titre = json['titre'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$CategorieEventToJson(CategorieEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
    };

SousCategorieEvent _$SousCategorieEventFromJson(Map<String, dynamic> json) =>
    SousCategorieEvent()
      ..id = json['id'] as String?
      ..titre = json['titre'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$SousCategorieEventToJson(SousCategorieEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
      'description': instance.description,
    };

OptionSousCategorieEvent _$OptionSousCategorieEventFromJson(
        Map<String, dynamic> json) =>
    OptionSousCategorieEvent()
      ..id = json['id'] as String?
      ..titre = json['titre'] as String?;

Map<String, dynamic> _$OptionSousCategorieEventToJson(
        OptionSousCategorieEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titre': instance.titre,
    };
