import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobsProvider with ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;

  List jobs = [];

  Future<List> getJobs() async {
    final temp = await databaseReference.collection('jobs').get();
    print(temp.docs.map((e) => e.data()).toList());
    jobs = temp.docs.map((e) => e.data()).toList();
    return temp.docs.map((e) => e.data()).toList();
  }

  List get jobsListGetter {
    return jobs;
  }
}
