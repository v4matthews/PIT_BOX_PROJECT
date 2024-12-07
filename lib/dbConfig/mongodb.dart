import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'constant.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var collection = db.collection(COLLECTION_USER);
    await collection.insertOne({"username": "aa", "password_user": "123"});
    print(await collection.find().toList());
  }
}
