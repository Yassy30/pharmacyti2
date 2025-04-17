🧠 Contexte du projet – Application de vente et livraison de médicaments
📝 Description générale
Cette application a pour but de connecter les clients, pharmacies, et livreurs dans un système de vente et de livraison de médicaments. Inspirée de Glovo mais spécialisée dans le secteur pharmaceutique, elle permet aux utilisateurs de commander des médicaments en ligne, aux pharmacies de gérer les commandes et aux livreurs de livrer efficacement.

👥 Types d'utilisateurs
Client

Pharmacie

Livreur

Administrateur (accès uniquement desktop)

🔐 Authentification & Vérification
Lors du signup, l’utilisateur choisit son type (client, livreur, pharmacie) :

Livreur : Doit uploader sa pièce d'identité, permis de conduire, et son numéro de téléphone. En attente de validation par l'admin.

Pharmacie : Doit uploader une photo de la pharmacie, sa localisation, et son numéro. En attente de validation par l'admin.

Client : Accès immédiat à son interface.

📱 Interface Client (Mobile/Desktop - Flutter)
Trouver les pharmacies proches de lui (appel, message, infos)

Upload d’ordonnance

Recherche de médicaments

Carte interactive avec localisation des pharmacies

Profil personnel (infos, historique…)

Panier + Paiement en ligne

🚚 Interface Livreur (Mobile - Flutter)
Liste des commandes disponibles avec :

Adresse de livraison

Détails des produits

Infos du client

Distance estimée

Détail d’une commande :

Accepter/refuser

Appel / message au client

Carte avec itinéraire vers le client

Historique de livraison

Profil livreur : stats, paiements, avis clients

🏪 Interface Pharmacie (Desktop - Flutter)
Dashboard : statistiques générales

Commandes reçues : suivi du statut

Gestion des médicaments : CRUD, stock, photos

Gestion des ordonnances

Chat avec les clients

Profil pharmacie visible aux clients

🧑‍💼 Interface Admin (Desktop - Flutter)
Dashboard global (nombre utilisateurs, commandes, livraisons…)

Gestion des utilisateurs (bloquer/supprimer)

Vérification des pharmacies et livreurs

Suivi des commandes (avec filtres)

Gestion des litiges

Paramètres généraux (catégories, sécurité…)

🧰 Technologies utilisées
Flutter : pour toutes les interfaces (mobile et desktop)

Supabase : base de données, auth, storage, API

Google Maps API : pour la géolocalisation, navigation

Flutterwave : solution de paiement par carte pour les clients