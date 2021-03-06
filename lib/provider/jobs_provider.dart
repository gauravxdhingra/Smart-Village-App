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
      // print(element.id);
      i++;
    });
    jobs = [];
    jobsList.forEach((ele) {
      jobs.add(Job(
        jobID: ele["id"],
        title: ele["title"],
        desc: ele["desc"],
        location: ele["location"],
        employerId: ele["employerId"],
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

  submitJob(Job job, employerId, context) async {
    await databaseReference.collection('jobs').add({
      "title": job.title,
      "hiringParty": job.hiringParty,
      "desc": job.desc,
      "imgUrl": job.imgUrl,
      "employerId": employerId,
      // == ""
      //     ? "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png"
      //     : job.imgUrl,
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
      "applied": []
    });
    return;
  }

  applyForJob(
      {String candidateId,
      String jobId,
      String candidateName,
      String jobTitle,
      String employerId}) async {
    // TODO Add to job db
    var temp = await databaseReference.collection('jobs').doc(jobId).get();
    var tempData = temp.data();
    List tempList = [];
    if (tempData["applied"] != null) {
      tempList = tempData["applied"];
      tempList.add({
        "candidateName": candidateName,
        "candidateId": candidateId,
      });
    }

    await databaseReference
        .collection('jobs')
        .doc(jobId)
        .update({"applied": tempList});

    // // TODO USER APPLIED JOBS

    var temp1 =
        await databaseReference.collection('users').doc(candidateId).get();
    var tempData1 = temp1.data();
    List tempList1 = [];
    if (tempData1["applied"] != null) {
      tempList = tempData1["applied"];
      tempList1.add({
        "jobId": jobId,
        "jobTitle": jobTitle,
      });
    }

    await databaseReference
        .collection('users')
        .doc(candidateId)
        .update({"applied": tempList1});

    // TODO EMPLOYER NOTIFICATION
    // print(employerId);
    // var temp2 =
    //     await databaseReference.collection('users').doc(employerId).get();
    // var tempData2 = temp2.data();
    // print(tempData2);
    // List tempList2 = [];

    // if (tempData2["notifications"] != null) {
    //   tempList2 = tempData2["notifications"];
    //   tempList2.add({
    //     "jobId": jobId,
    //     "jobTitle": jobTitle,
    //     "candidateName": candidateName,
    //     "candidateId": candidateId,
    //   });
    //   print(tempData2["notifications"]);
    // }

    // await databaseReference
    //     .collection('users')
    //     .doc(employerId)
    //     .update({"applied": tempList2});
  }

  Future<List> getAppliedJobsByUser(candidateId) async {
    var temp2 =
        await databaseReference.collection('users').doc(candidateId).get();
    var tempData2 = temp2.data();
    return tempData2["applied"];
  }

  List<Job> get jobsListGetter {
    return jobs;
  }
}
