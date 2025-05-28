import 'package:json_annotation/json_annotation.dart';
// part 'operation_model.g.dart';

@JsonSerializable()
class Championnat {
  String? id;
  String titre;
  String? logoUrl;
  @JsonKey(name: 'created_at')
  int createdAt;
  @JsonKey(name: 'updated_at')
  int updatedAt;

  Championnat copyWith({String? logoUrl}) {
    return Championnat(
      titre: titre,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Championnat({
    required this.titre,
    this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  //
  // factory Championnat.fromJson(Map<String, dynamic> json) => _$ChampionnatFromJson(json);
  // Map<String, dynamic> toJson() => _$ChampionnatToJson(this);
}
//
// @JsonSerializable()
// class Club {
//   String? id;
//   String nom;
//   String? logoUrl;
//   @JsonKey(name: 'championnat_id')
//   String championnatId;
//   String ville;
//   String pays;
//   @JsonKey(name: 'annee_fondation')
//   int anneeFondation;
//   @JsonKey(name: 'created_at')
//   int createdAt;
//   @JsonKey(name: 'updated_at')
//   int updatedAt;
//
//   Club({
//     required this.nom,
//     this.logoUrl,
//     required this.championnatId,
//     required this.ville,
//     required this.pays,
//     required this.anneeFondation,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
//   Map<String, dynamic> toJson() => _$ClubToJson(this);
// }
//
//
// @JsonSerializable()
// class Saison {
//   String? id;
//   @JsonKey(name: 'championnat_id')
//   String championnatId;
//   String nom; // Ex: "Saison 2023-2024"
//   @JsonKey(name: 'date_debut')
//   int dateDebut; // Timestamp en microsecondes
//   @JsonKey(name: 'date_fin')
//   int dateFin;
//   @JsonKey(name: 'created_at')
//   int createdAt;
//   @JsonKey(name: 'updated_at')
//   int updatedAt;
//
//   Saison({
//     required this.championnatId,
//     required this.nom,
//     required this.dateDebut,
//     required this.dateFin,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Saison.fromJson(Map<String, dynamic> json) => _$SaisonFromJson(json);
//   Map<String, dynamic> toJson() => _$SaisonToJson(this);
// }
//
// @JsonSerializable()
// class Journee {
//   String? id;
//   @JsonKey(name: 'saison_id')
//   String saisonId;
//   @JsonKey(name: 'championnat_id')
//   String championnatId;
//   @JsonKey(name: 'numero_journee')
//   int numeroJournee;
//   @JsonKey(name: 'date_debut')
//   int dateDebut;
//   @JsonKey(name: 'date_fin')
//   int dateFin;
//   String statut; // 'À venir', 'En cours', 'Terminée'
//   @JsonKey(name: 'created_at')
//   int createdAt;
//   @JsonKey(name: 'updated_at')
//   int updatedAt;
//
//   Journee({
//     required this.saisonId,
//     required this.championnatId,
//     required this.numeroJournee,
//     required this.dateDebut,
//     required this.dateFin,
//     required this.statut,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory Journee.fromJson(Map<String, dynamic> json) => _$JourneeFromJson(json);
//   Map<String, dynamic> toJson() => _$JourneeToJson(this);
// }
//
// @JsonSerializable()
// class Match {
//   String? id;
//   @JsonKey(name: 'journee_id')
//   String journeeId;
//   @JsonKey(name: 'club_domicile_id')
//   String clubDomicileId;
//   @JsonKey(name: 'club_exterieur_id')
//   String clubExterieurId;
//   @JsonKey(name: 'score_domicile')
//   int scoreDomicile;
//   @JsonKey(name: 'score_exterieur')
//   int scoreExterieur;
//   String statut; // 'Planifié', 'En cours', 'Terminé', 'Reporté'
//   @JsonKey(name: 'date_match')
//   int dateMatch;
//   Map<String, dynamic> statistiques;
//   @JsonKey(name: 'created_at')
//   int createdAt;
//   @JsonKey(name: 'updated_at')
//   int updatedAt;
//
//   Match({
//     required this.journeeId,
//     required this.clubDomicileId,
//     required this.clubExterieurId,
//     this.scoreDomicile = 0,
//     this.scoreExterieur = 0,
//     required this.statut,
//     required this.dateMatch,
//     required this.statistiques,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   // Exemple de statistiques:
//   // {
//   //   'possession': {'domicile': 55, 'exterieur': 45},
//   //   'tirs': 12,
//   //   'tirs_cadres': 5,
//   //   'fautes': 18,
//   //   'corners': 6,
//   //   'hors_jeu': 3,
//   //   'cartons_jaunes': 2,
//   //   'cartons_rouges': 0
//   // }
//
//   factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
//   Map<String, dynamic> toJson() => _$MatchToJson(this);
// }