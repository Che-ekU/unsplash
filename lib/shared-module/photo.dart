import 'dart:convert';

PhotoSchema photoFromJson(String str) => PhotoSchema.fromJson(json.decode(str));

String photoToJson(PhotoSchema data) => json.encode(data.toJson());

class PhotoSchema {
    final String id;
    final String slug;
    final DateTime createdAt;
    final DateTime updatedAt;
    final DateTime promotedAt;
    final int width;
    final int height;
    final String color;
    final String blurHash;
    final String description;
    final String altDescription;
    final List<dynamic> breadcrumbs;
    final Urls urls;
    final PhotoLinks links;
    final int likes;
    final bool likedByUser;
    final List<dynamic> currentUserCollections;
    final Sponsorship sponsorship;
    final TopicSubmissions topicSubmissions;
    final User user;

    PhotoSchema({
        required this.id,
        required this.slug,
        required this.createdAt,
        required this.updatedAt,
        required this.promotedAt,
        required this.width,
        required this.height,
        required this.color,
        required this.blurHash,
        required this.description,
        required this.altDescription,
        required this.breadcrumbs,
        required this.urls,
        required this.links,
        required this.likes,
        required this.likedByUser,
        required this.currentUserCollections,
        required this.sponsorship,
        required this.topicSubmissions,
        required this.user,
    });

    factory PhotoSchema.fromJson(Map<String, dynamic> json) => PhotoSchema(
        id: json["id"],
        slug: json["slug"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        promotedAt: DateTime.parse(json["promoted_at"]),
        width: json["width"],
        height: json["height"],
        color: json["color"],
        blurHash: json["blur_hash"],
        description: json["description"],
        altDescription: json["alt_description"],
        breadcrumbs: List<dynamic>.from(json["breadcrumbs"].map((x) => x)),
        urls: Urls.fromJson(json["urls"]),
        links: PhotoLinks.fromJson(json["links"]),
        likes: json["likes"],
        likedByUser: json["liked_by_user"],
        currentUserCollections: List<dynamic>.from(json["current_user_collections"].map((x) => x)),
        sponsorship: Sponsorship.fromJson(json["sponsorship"]),
        topicSubmissions: TopicSubmissions.fromJson(json["topic_submissions"]),
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "promoted_at": promotedAt.toIso8601String(),
        "width": width,
        "height": height,
        "color": color,
        "blur_hash": blurHash,
        "description": description,
        "alt_description": altDescription,
        "breadcrumbs": List<dynamic>.from(breadcrumbs.map((x) => x)),
        "urls": urls.toJson(),
        "links": links.toJson(),
        "likes": likes,
        "liked_by_user": likedByUser,
        "current_user_collections": List<dynamic>.from(currentUserCollections.map((x) => x)),
        "sponsorship": sponsorship.toJson(),
        "topic_submissions": topicSubmissions.toJson(),
        "user": user.toJson(),
    };
}

class PhotoLinks {
    final String self;
    final String html;
    final String download;
    final String downloadLocation;

    PhotoLinks({
        required this.self,
        required this.html,
        required this.download,
        required this.downloadLocation,
    });

    factory PhotoLinks.fromJson(Map<String, dynamic> json) => PhotoLinks(
        self: json["self"],
        html: json["html"],
        download: json["download"],
        downloadLocation: json["download_location"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "html": html,
        "download": download,
        "download_location": downloadLocation,
    };
}

class Sponsorship {
    final List<String> impressionUrls;
    final String tagline;
    final String taglineUrl;
    final User sponsor;

    Sponsorship({
        required this.impressionUrls,
        required this.tagline,
        required this.taglineUrl,
        required this.sponsor,
    });

    factory Sponsorship.fromJson(Map<String, dynamic> json) => Sponsorship(
        impressionUrls: List<String>.from(json["impression_urls"].map((x) => x)),
        tagline: json["tagline"],
        taglineUrl: json["tagline_url"],
        sponsor: User.fromJson(json["sponsor"]),
    );

    Map<String, dynamic> toJson() => {
        "impression_urls": List<dynamic>.from(impressionUrls.map((x) => x)),
        "tagline": tagline,
        "tagline_url": taglineUrl,
        "sponsor": sponsor.toJson(),
    };
}

class User {
    final String id;
    final DateTime updatedAt;
    final String username;
    final String name;
    final String firstName;
    final dynamic lastName;
    final String twitterUsername;
    final String portfolioUrl;
    final String bio;
    final String location;
    final UserLinks links;
    final ProfileImage profileImage;
    final String instagramUsername;
    final int totalCollections;
    final int totalLikes;
    final int totalPhotos;
    final bool acceptedTos;
    final bool forHire;
    final Social social;

    User({
        required this.id,
        required this.updatedAt,
        required this.username,
        required this.name,
        required this.firstName,
        this.lastName,
        required this.twitterUsername,
        required this.portfolioUrl,
        required this.bio,
        required this.location,
        required this.links,
        required this.profileImage,
        required this.instagramUsername,
        required this.totalCollections,
        required this.totalLikes,
        required this.totalPhotos,
        required this.acceptedTos,
        required this.forHire,
        required this.social,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        username: json["username"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        twitterUsername: json["twitter_username"],
        portfolioUrl: json["portfolio_url"],
        bio: json["bio"],
        location: json["location"],
        links: UserLinks.fromJson(json["links"]),
        profileImage: ProfileImage.fromJson(json["profile_image"]),
        instagramUsername: json["instagram_username"],
        totalCollections: json["total_collections"],
        totalLikes: json["total_likes"],
        totalPhotos: json["total_photos"],
        acceptedTos: json["accepted_tos"],
        forHire: json["for_hire"],
        social: Social.fromJson(json["social"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "updated_at": updatedAt.toIso8601String(),
        "username": username,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "twitter_username": twitterUsername,
        "portfolio_url": portfolioUrl,
        "bio": bio,
        "location": location,
        "links": links.toJson(),
        "profile_image": profileImage.toJson(),
        "instagram_username": instagramUsername,
        "total_collections": totalCollections,
        "total_likes": totalLikes,
        "total_photos": totalPhotos,
        "accepted_tos": acceptedTos,
        "for_hire": forHire,
        "social": social.toJson(),
    };
}

class UserLinks {
    final String self;
    final String html;
    final String photos;
    final String likes;
    final String portfolio;
    final String following;
    final String followers;

    UserLinks({
        required this.self,
        required this.html,
        required this.photos,
        required this.likes,
        required this.portfolio,
        required this.following,
        required this.followers,
    });

    factory UserLinks.fromJson(Map<String, dynamic> json) => UserLinks(
        self: json["self"],
        html: json["html"],
        photos: json["photos"],
        likes: json["likes"],
        portfolio: json["portfolio"],
        following: json["following"],
        followers: json["followers"],
    );

    Map<String, dynamic> toJson() => {
        "self": self,
        "html": html,
        "photos": photos,
        "likes": likes,
        "portfolio": portfolio,
        "following": following,
        "followers": followers,
    };
}

class ProfileImage {
    final String small;
    final String medium;
    final String large;

    ProfileImage({
        required this.small,
        required this.medium,
        required this.large,
    });

    factory ProfileImage.fromJson(Map<String, dynamic> json) => ProfileImage(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
    );

    Map<String, dynamic> toJson() => {
        "small": small,
        "medium": medium,
        "large": large,
    };
}

class Social {
    final String instagramUsername;
    final String portfolioUrl;
    final String twitterUsername;
    final dynamic paypalEmail;

    Social({
        required this.instagramUsername,
        required this.portfolioUrl,
        required this.twitterUsername,
        this.paypalEmail,
    });

    factory Social.fromJson(Map<String, dynamic> json) => Social(
        instagramUsername: json["instagram_username"],
        portfolioUrl: json["portfolio_url"],
        twitterUsername: json["twitter_username"],
        paypalEmail: json["paypal_email"],
    );

    Map<String, dynamic> toJson() => {
        "instagram_username": instagramUsername,
        "portfolio_url": portfolioUrl,
        "twitter_username": twitterUsername,
        "paypal_email": paypalEmail,
    };
}

class TopicSubmissions {
    TopicSubmissions();

    factory TopicSubmissions.fromJson(Map<String, dynamic> json) => TopicSubmissions(
    );

    Map<String, dynamic> toJson() => {
    };
}

class Urls {
    final String raw;
    final String full;
    final String regular;
    final String small;
    final String thumb;
    final String smallS3;

    Urls({
        required this.raw,
        required this.full,
        required this.regular,
        required this.small,
        required this.thumb,
        required this.smallS3,
    });

    factory Urls.fromJson(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
        smallS3: json["small_s3"],
    );

    Map<String, dynamic> toJson() => {
        "raw": raw,
        "full": full,
        "regular": regular,
        "small": small,
        "thumb": thumb,
        "small_s3": smallS3,
    };
}
