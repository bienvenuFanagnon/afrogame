import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_models.g.dart';
/* flutter pub run build_runner build */
enum PostType { POST, PUB,ARTICLE,CHALLENGE,SERVICE }

enum PostDataType { IMAGE, VIDEO, TEXT, COMMENT }

enum PostStatus { VALIDE, SIGNALER, NONVALIDE, SUPPRIMER }

enum ChatType { USER, ENTREPRISE }

enum IsSendMessage { SENDING, NOTSENDING }

enum InfoType { APPINFO, GRATUIT }

enum NotificationType {
  MESSAGE,
  POST,
  INVITATION,
  ACCEPTINVITATION,
  ABONNER,
  PARRAINAGE,
  ARTICLE,
  CHALLENGE,
  CHRONIQUE,
  SERVICE,
  USER, COMMENT
}
enum EventStatus {
  encours,
  valider,
  payer,
  passer,
  nonpayer,
  supprimer,
}

enum MediaType {
  photo,
  video,
}

enum TypeJeu {
  AlaUne,
  GAMESTORY,
  EVENEMENT,
}
enum UserRole { ADM, USER }



@JsonSerializable()
class UserData {
  String? id;
  String? pseudo = "";
  late String? oneIgnalUserid = "";
  List<String>? userabonnements=[];

  String? nom;
  String? prenom;
  String? telephone;
  String? urlImage;
  bool? isVerify=false;
  int? solde=0;
  double? note=0.1;
  String? adresse = "";
  String? email = "";
  String? genre = "";
  String? codeParrainage;
  String? codeParrain;
  String? role;


  UserData();

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class AppDefaultData {
  String? id;
  String? app_link;
  bool? isWaitingForPlaystore=false;

  late int app_version = 0;
  late String app_logo = "";
  late String one_signal_api_key = "";
  late String one_signal_app_id = "";
  late String one_signal_app_url = "";
  // int? default_point_new_comment=2;

  AppDefaultData();

  factory AppDefaultData.fromJson(Map<String, dynamic> json) => _$AppDefaultDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppDefaultDataToJson(this);
}


// EventData model
@JsonSerializable()
class EventData {
  String? id;
  String? userId;
  String? titre;
  String? description;
  String? statut;
  String? idCategorie;
  String? categorie;
  String? idSousCategorie;
  String? sousCategorie;
  String? typeJeu;
  String? urlPosition;
  double? longitude;
  double? latitude;
  String? pays;
  String? ville;
  String? adresse;
  List<String>? userslikes=[];
  List<String>? usersVues=[];
  int? vue=0;
  int? like=0;
  int? partage=0;
  int? commentaire=0;
  int? createdAt;
  int? updatedAt;
  int? nombreJourAvantDisparition;
  int? date;
  List<Map<String, String?>> medias = [
  ];
  String? urlMedia;
  String? typeMedia;
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserData? user;

  EventData();

  factory EventData.fromJson(Map<String, dynamic> json) => _$EventDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}

// CategorieEvent model
@JsonSerializable()
class CategorieEvent {
  String? id;
  String? titre;
  String? description;

  CategorieEvent();

  factory CategorieEvent.fromJson(Map<String, dynamic> json) => _$CategorieEventFromJson(json);

  Map<String, dynamic> toJson() => _$CategorieEventToJson(this);
}

// SousCategorieEvent model
@JsonSerializable()
class SousCategorieEvent {
  String? id;
  String? titre;
  String? description;

  SousCategorieEvent();

  factory SousCategorieEvent.fromJson(Map<String, dynamic> json) => _$SousCategorieEventFromJson(json);

  Map<String, dynamic> toJson() => _$SousCategorieEventToJson(this);
}

// OptionSousCategorieEvent model
@JsonSerializable()
class OptionSousCategorieEvent {
  String? id;
  String? titre;

  OptionSousCategorieEvent();

  factory OptionSousCategorieEvent.fromJson(Map<String, dynamic> json) => _$OptionSousCategorieEventFromJson(json);

  Map<String, dynamic> toJson() => _$OptionSousCategorieEventToJson(this);
}

class PostComment {
  String? id;
  String? user_id;
  String? post_id;
  String? status;
  String? message;
  int? createdAt;
  int? updatedAt;
  List<int>? users_like_id = [];

  int? comments = 0;
  int? loves = 0;
  int? likes = 0;
  UserData? user;
  List<ResponsePostComment>? responseComments = [];
  List<Message>? replycommentaires = [];

  PostComment({
    this.id,
    this.comments,
    this.users_like_id,
    this.user_id,
    this.status,
    this.message,
    this.post_id,
    this.responseComments,
    this.loves,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  PostComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comments = json['comments'];
    user_id = json['user_id'];
    status = json['status'];
    post_id = json['post_id'];
    message = json['message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    users_like_id =
    json['users_like_id'] == null ? [] : json['users_like_id'].cast<int>();
    loves = json['loves'];
    likes = json['likes'];
    if (json['responseComments'] != null) {
      responseComments = <ResponsePostComment>[];
      json['responseComments'].forEach((v) {
        responseComments!.add(new ResponsePostComment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comments'] = this.comments;
    data['user_id'] = this.user_id;
    data['status'] = this.status;
    data['message'] = this.message;
    data['users_like_id'] = this.users_like_id;
    data['post_id'] = this.post_id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['responseComments'] =
        responseComments!.map((response) => response.toJson()).toList();

    data['loves'] = this.loves;
    data['likes'] = this.likes;

    return data;
  }
}

class ResponsePostComment {
  String? id;
  String? post_comment_id;
  String? user_id;
  String? user_logo_url;
  String? user_pseudo;
  String? user_reply_pseudo;
  String? message;
  String? status;
  UserData? user;

  int? createdAt;
  int? updatedAt;

  ResponsePostComment({
    this.id = '',
    this.message = '',
    this.user_pseudo = '',
    this.user_logo_url = '',
    this.post_comment_id = '',
    this.user_reply_pseudo = '',
    this.status = '',
    required this.user_id,
    this.createdAt = 0,
    this.updatedAt = 0,
    // required this.user,
  });

  ResponsePostComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    message = json['message'];
    user_pseudo = json['user_pseudo'];
    user_logo_url = json['user_logo_url'];
    post_comment_id = json['post_comment_id'];
    user_reply_pseudo = json['user_reply_pseudo'] == null ? "" : json['user_reply_pseudo'];
    user_id = json['user_id'] == null ? "" : json['user_id'];
    status = json['status'] == null ? "" : json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['message'] = this.message;
    data['status'] = this.status;
    data['user_pseudo'] = this.user_pseudo;
    data['user_reply_pseudo'] = this.user_reply_pseudo;
    data['user_logo_url'] = this.user_logo_url;
    data['post_comment_id'] = this.post_comment_id;
    data['user_id'] = this.user_id;

    return data;
  }
}
class Message {
  /// Provides id
  late String id;

  /// Used for accessing widget's render box.
  final GlobalKey key;

  /// Provides actual message it will be text or image/audio file path.
  late String message;
  late bool is_valide;
  final bool send_sending;
  final bool receiver_sending;
  final String sendBy;

  late  String message_state='';

  /// Provides message created date time.
  final DateTime createdAt;

  /// Provides id of sender of message.
  final String receiverBy;
  final String chat_id;

  /// Provides reply message if user triggers any reply on any message.
  late ReplyMessage replyMessage;

  /// Represents reaction on message.
  final Reaction reaction;

  /// Provides message type.
  String messageType;
  int create_at_time_spam;

  /// Status of the message.
  final ValueNotifier<MessageStatus> _status;

  /// Provides max duration for recorded voice message.
  Duration? voiceMessageDuration;

  Message(    {
    this.is_valide=true,
    this.send_sending=false,
    this.receiver_sending=false,
    this.message_state='',
    required this.receiverBy,
    required this.chat_id,
    required this.create_at_time_spam,
    this.id = '',
    required this.message,
    required this.createdAt,
    required this.sendBy,
    required this.replyMessage ,
    Reaction? reaction,
    required this.messageType,
    this.voiceMessageDuration,
    MessageStatus status = MessageStatus.pending,
  })  : reaction = reaction ?? Reaction(reactions: [], reactedUserIds: []),
        key = GlobalKey(),
        _status = ValueNotifier(status),
        assert(
        (messageType==MessageType.voice.name
            ? ((defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android))
            : true),
        "Voice messages are only supported with android and ios platform",
        );

  /// curret messageStatus
  MessageStatus get status => _status.value;

  /// For [MessageStatus] ValueNotfier which is used to for rebuilds
  /// when state changes.
  /// Using ValueNotfier to avoid usage of setState((){}) in order
  /// rerender messages with new receipts.
  ValueNotifier<MessageStatus> get statusNotifier => _status;

  /// This setter can be used to update message receipts, after which the configured
  /// builders will be updated.
  set setStatus(MessageStatus messageStatus) {
    _status.value = messageStatus;
  }


  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"].toString(),
    message: json["message"],
    createdAt:DateTime.fromMillisecondsSinceEpoch(json["create_at_time_spam"]),
    sendBy: json["send_by"],
    is_valide: json["is_valide"]==null?true:json["is_valide"],
    send_sending: json["send_sending"]==null?false:json["send_sending"],
    receiver_sending: json["receiver_sending"]==null?false:json["receiver_sending"],
    replyMessage: ReplyMessage.fromJson(json["reply_message"]),
    reaction: Reaction.fromJson(json["reaction"]),
    messageType: json["message_type"],
    voiceMessageDuration: json["voice_message_duration"],
    status:json['status']==MessageStatus.pending.name?MessageStatus.pending:json['status']==MessageStatus.read.name?MessageStatus.read:json['status']==MessageStatus.delivered.name?MessageStatus.delivered:json['status']==MessageStatus.undelivered.name?MessageStatus.undelivered:MessageStatus.undelivered,
    chat_id: json['chat_id'],
    create_at_time_spam: json['create_at_time_spam'],
    message_state: json['message_state'], receiverBy: json['receiverBy'],
  )
  ;

  Map<String, dynamic> toJson() => {
    'id': id,
    'message': message,
    'createdAt': createdAt,
    'send_by': sendBy,
    'receiver_sending': receiver_sending,
    'send_sending': send_sending,
    'is_valide': is_valide,
    'chat_id': chat_id,
    'reply_message': replyMessage.toJson(),
    'reaction': reaction.toJson(),
    'message_type': messageType,
    'create_at_time_spam': create_at_time_spam,
    'voice_message_duration': voiceMessageDuration,
    'status': status.name,
    'message_state': message_state,
    'receiverBy': receiverBy
  };
}

class ReplyMessage {
  /// Provides reply message.
  late  String message;

  /// Provides user id of who replied message.
  final String replyBy;

  /// Provides user id of whom to reply.
  final String replyTo;
  late final String messageType;

  /// Provides max duration for recorded voice message.
  final Duration? voiceMessageDuration;

  /// Id of message, it replies to.
  late final String messageId;

  ReplyMessage({
    this.messageId="",
    required this.message,
    this.replyTo="",
    this.replyBy="",
    required this.messageType,
    this.voiceMessageDuration,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) => ReplyMessage(
    message: json['message'],
    replyBy: json['replyBy'],
    replyTo: json['replyTo'],
    messageType: json["message_type"],
    messageId: json["id"],
    voiceMessageDuration: json["voiceMessageDuration"],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'replyBy': replyBy,
    'replyTo': replyTo,
    'message_type': messageType,
    'id': messageId,
    'voiceMessageDuration': voiceMessageDuration,
  };
}

class Reaction {
  Reaction({
    required this.reactions,
    required this.reactedUserIds,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
    reactions: json['reactions'].cast<String>(),
    reactedUserIds: json['reactedUserIds'].cast<String>(),
  );

  /// Provides list of reaction in single message.
  final List<String> reactions;

  /// Provides list of user who reacted on message.
  final List<String> reactedUserIds;

  Map<String, dynamic> toJson() => {
    'reactions': reactions,
    'reactedUserIds': reactedUserIds,
  };
}

class NotificationData {
  String? id;
  String? media_url;
  String? user_id;
  String? post_id;
  String? receiver_id;
  String? post_data_type;
  String? type;
  String? titre;
  String? status;
  UserData? userData;
  bool? is_open;
  String? description;
  List<String>? users_id_view = [];

  int? createdAt;
  int? updatedAt;

  NotificationData({
    this.id = '',
    this.type = '',
    this.description = '',
    this.titre = '',
    this.status = '',
    this.media_url = '',
    // this.lu=false,
    this.is_open = false,
    this.post_data_type = '',
    this.post_id = '',
    this.user_id = '',
    this.receiver_id = '',
    this.createdAt = 0,
    this.updatedAt = 0,
    this.users_id_view,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    status = json['status'];
    user_id = json['user_id'];
    receiver_id = json['receiver_id'] == null ? "" : json['receiver_id'];
    is_open = json['is_open'] == null ? false : json['is_open'];
    post_data_type =
    json['post_data_type'] == null ? "" : json['post_data_type'];
    post_id = json['post_id'] == null ? "" : json['post_id'];
    users_id_view = json['users_id_view'] == null
        ? []
        : json['users_id_view'].cast<String>();

    description = json['description'];
    titre = json['titre'];
    media_url = json['media_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    data['user_id'] = this.user_id;
    data['receiver_id'] = this.receiver_id;
    data['status'] = this.status;
    data['is_open'] = this.is_open;
    data['users_id_view'] = this.users_id_view;
    data['post_data_type'] = this.post_data_type;

    data['description'] = this.description;
    data['post_id'] = this.post_id;
    data['titre'] = this.titre;
    data['media_url'] = this.media_url;

    return data;
  }
}

enum MessageState { LU, NONLU }

/// Events, Wheter the user is still typing a message or has
/// typed the message
enum TypeWriterStatus { typing, typed }

/// [MessageStatus] defines the current state of the message
/// if you are sender sending a message then, the
enum MessageStatus { read, delivered, undelivered, pending }

enum MessageType {
  image,
  text,

  /// Only supported on android and ios
  voice,
  custom
}