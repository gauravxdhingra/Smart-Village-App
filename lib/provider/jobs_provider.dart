import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:smart_village/models/job.dart';

class JobsProvider with ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;

  List jobs = [];

  Future<List> getJobs() async {
    final temp = await databaseReference.collection('jobs').get();
    jobs = temp.docs.map((e) => e.data()).toList();
    int i = 0;
    temp.docs.forEach((element) {
      jobs[i]["id"] = element.id;
      i++;
    });
    // print(jobs);
    return jobs;
  }

  getJobById(String jobid) async {
    final temp = await databaseReference.collection('jobs').doc(jobid).get();

    print(temp.data());
    return jobs;
  }

  submitJob(Job job, context) async {
    await databaseReference.collection('jobs').add({
      "title": job.title,
      "hiringParty": job.hiringParty,
      "desc": job.desc,
      "imgUrl": job.imgUrl == ""
          ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png"
          : job.imgUrl,
      "startDate": job.startDate == null ? "" : job.startDate.toIso8601String(),
      "endDate": job.endDate == null ? "" : job.endDate.toIso8601String(),
      "postedAt": DateTime.now().toIso8601String(),
      "salary": job.salary,
      "location": job.location,
      "lat": job.lat ?? 0.00,
      "long": job.long ?? 0.00,
      "startTime": job.startTime.format(context),
      "endTime": job.endTime.format(context),
      "jobTags": job.jobTags,
      "specialNotes": job.specialNotes,
      "jobtypeIndex": job.jobTypeIndex,
    });
    return;
  }

  List get jobsListGetter {
    return jobs;
  }
}
