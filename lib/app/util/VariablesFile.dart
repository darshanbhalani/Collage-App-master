import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

String collage_name = "Vidush Somani Institute of Technology & Research";
String current_user_enrollmentno = "";
String current_user_name = "";
String current_user_photo = "";
String current_user_first_name = "";
String current_user_middle_name = "";
String current_user_last_name = "";
String current_user_bloodgroup = "";
String current_user_branch = "";
String current_user_semester = "";
String current_user_class = "";
String current_user_birthdate = "";
String current_user_department = "";
String current_user_joining_date = "";
String current_user_year = "";
String current_user_validity = "";
String current_user_phoneno = "";
String current_user_email = "";
String current_user_type = "";
Color button_color = (Colors.blue);
bool isHomeScreenLoaded = false;
String clicked_event_title = "";
String clicked_event_about = "";
String clicked_event_coordinator = "";
String clicked_event_coverphoto = "";
Timestamp? timestamp;
DateTime? clicked_event_duedate;
String? clicked_event_link;
String? selected_class;
bool isLoading = false;
bool? defaultTheme;
bool? darkTheme;
Color PrimaryColor = Colors.blue;
DefaultCacheManager? file;
List<String> classNames = [];

List<DropDownValueModel> Courses = [
  DropDownValueModel(name: "Automobile", value: "Automobile"),
  DropDownValueModel(name: "Civil", value: "Civil"),
  DropDownValueModel(name: "Computer", value: "Computer"),
  DropDownValueModel(name: "Electrical", value: "Electrical"),
  DropDownValueModel(name: "IT", value: "IT"),
  DropDownValueModel(name: "Mechenical", value: "Mechenical"),
];

List<DropDownValueModel> Semesters = [
  DropDownValueModel(name: "1st", value: "1st"),
  DropDownValueModel(name: "2nd", value: "2nd"),
  DropDownValueModel(name: "3rd", value: "3rd"),
  DropDownValueModel(name: "4th", value: "4th"),
  DropDownValueModel(name: "5th", value: "5th"),
  DropDownValueModel(name: "6th", value: "6th"),
  DropDownValueModel(name: "7th", value: "7th"),
  DropDownValueModel(name: "8th", value: "8th"),
];

List<DropDownValueModel> BloodGroups = [
  DropDownValueModel(name: "A+", value: "A+"),
  DropDownValueModel(name: "B+", value: "B+"),
  DropDownValueModel(name: "O+", value: "O+"),
  DropDownValueModel(name: "AB+", value: "AB+"),
  DropDownValueModel(name: "A-", value: "A-"),
  DropDownValueModel(name: "B-", value: "B-"),
  DropDownValueModel(name: "O-", value: "O-"),
  DropDownValueModel(name: "AB-", value: "AB-"),
];
