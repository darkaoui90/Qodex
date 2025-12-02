erDiagram
  UTILISATEURS {
    int id_utilisateur PK
    string nom
    string email
    string motdepasse
    string role
  }

  CATEGORIES {
    int id_categorie PK
    string nom_categorie
  }

  QUIZ {
    int id_quiz PK
    string titre_quiz
    string description
    int id_categorie FK
    int id_enseignant FK
    int duree_minutes
    datetime date_creation
  }

  QUESTIONS {
    int id_question PK
    string texte_question
    string reponse_correcte
    int points
    int id_quiz FK
  }

  RESULTATS {
    int id_resultat PK
    int score
    datetime date_passage
    int id_etudiant FK
    int id_quiz FK
  }

  CATEGORIES ||--o{ QUIZ : "id_categorie"
  UTILISATEURS ||--o{ QUIZ : "id_utilisateur -> id_enseignant"
  QUIZ ||--o{ QUESTIONS : "id_quiz"
  UTILISATEURS ||--o{ RESULTATS : "id_utilisateur -> id_etudiant"
  QUIZ ||--o{ RESULTATS : "id_quiz"