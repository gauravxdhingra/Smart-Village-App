import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:smart_village/models/job.dart';

class JobsProvider with ChangeNotifier {
  final databaseReference = FirebaseFirestore.instance;

  List<Job> jobs = [];

  Future<List> getJobs() async {
    final temp = await databaseReference.collection('jobs').get();
    List jobsList = [];
    jobsList = temp.docs.map((e) => e.data()).toList();
    int i = 0;
    temp.docs.forEach((element) {
      jobsList[i]["id"] = element.id;
      i++;
    });
    jobs = [];
    jobsList.forEach((ele) {
      jobs.add(Job(
        jobID: ele["jobID"],
        title: ele["title"],
        desc: ele["desc"],
        location: ele["location"],
        endDate: ele["endDate"] != null && ele["endDate"] != ""
            ? DateTime.parse(ele["endDate"])
            : null,
        endTime: TimeOfDay(
            minute: int.parse(
                ele["endTime"].toString().split(":")[1].split(" ")[0]),
            hour: ele["endTime"].toString().split(" ")[1] == "PM"
                ? 12 + int.parse(ele["endTime"].toString().split(":")[0])
                : int.parse(ele["endTime"].toString().split(":")[0])),
        hiringParty: ele["hiringParty"],
        imgUrl: ele["imgUrl"],
        jobTags: ele["jobTags"],
        jobTypeIndex: ele["jobtypeIndex"],
        lat: ele["lat"],
        long: ele["long"],
        postedAt: ele["postedAt"],
        salary: double.parse(ele["salary"].toString()),
        specialNotes: ele["specialNotes"],
        startDate: ele["startDate"] != null && ele["startDate"] != ""
            ? DateTime.parse(ele["startDate"])
            : null,
        startTime: TimeOfDay(
            minute: int.parse(
                ele["startTime"].toString().split(":")[1].split(" ")[0]),
            hour: ele["startTime"].toString().split(" ")[1] == "PM"
                ? 12 + int.parse(ele["startTime"].toString().split(":")[0])
                : int.parse(ele["startTime"].toString().split(":")[0])),
      ));
    });
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

  List<Job> get jobsListGetter {
    return jobs;
  }
}
