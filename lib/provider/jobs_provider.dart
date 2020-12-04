import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:smart_village/models/job.dart';

class JobsProvider with ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;

  List jobs = [];

  Future<List> getJobs() async {
    final temp = await databaseReference.collection('jobs').get();
    print(temp.docs.map((e) => e.data()).toList());
    jobs = temp.docs.map((e) => e.data()).toList();
    return temp.docs.map((e) => e.data()).toList();
  }

  submitJob(Job job) async {
    await databaseReference.collection('jobs').add({
      "title": job.title,
      "hiringParty": job.hiringParty,
      "desc": job.desc,
      "imgUrl": job.imgUrl == ""
          ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png"
          : job.imgUrl,
      "startDate": job.startDate.toIso8601String(),
      "endDate": job.endDate == null ? "" : job.endDate.toIso8601String(),
      "postedAt": DateTime.now().toIso8601String(),
      "salary": job.salary,
      "location": job.location,
      "lat": job.lat ?? 0.00,
      "long": job.long ?? 0.00,
    });
    return;
  }

  List get jobsListGetter {
    return jobs;
  }
}
