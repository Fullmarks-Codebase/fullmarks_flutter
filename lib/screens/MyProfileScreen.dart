import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/models/CommonResponse.dart';
import 'package:fullmarks/models/UserResponse.dart';
import 'package:fullmarks/models/UsersResponse.dart';
import 'package:fullmarks/utility/ApiManager.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppFirebaseAnalytics.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/PreferenceUtils.dart';
import 'package:fullmarks/utility/Utiity.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'ChangeGradeScreen.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Customer customer;
  bool _isLoading = false;
  File _image;
  final _picker = ImagePicker();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool isEdit = false;
  int maleFemale = -1;
  String dob = "";

  @override
  void initState() {
    AppFirebaseAnalytics.init().logEvent(name: AppStrings.myProfileEvent);
    customer = Utility.getCustomer();
    _notify();
    init();
    _getUser();
    super.initState();
  }

  init() {
    _phoneController.text = customer.phoneNumber;
    _usernameController.text = customer.username == "" ? "" : customer.username;
    _emailController.text = customer.email == "" ? "" : customer.email;
    maleFemale = customer.gender;
    dob = customer.dob == "" ? "" : customer.dob.substring(0, 10);
    _notify();
  }

  _getUser() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["customerId"] = customer.id.toString();
      //api call
      UsersResponse response = UsersResponse.fromJson(
        await ApiManager(context)
            .postCall(url: AppStrings.customer, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      if (response.code == 200) {
        if (response.result.length > 0) {
          Customer tempCustomer = response.result.first;
          tempCustomer.token = customer.token;
          await PreferenceUtils.setString(
              AppStrings.userPreference, jsonEncode(tempCustomer.toJson()));
          customer = Utility.getCustomer();
          _notify();
          init();
        }
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  _notify() {
    //notify internal state change in objects
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.profileBg),
          body(),
          Column(
            children: [
              Utility.appbar(
                context,
                text: "",
                isHome: false,
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget profileDetails() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Profile Detail",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Container(
                        height: 15,
                        width: 15,
                        margin: EdgeInsets.all(16),
                        child: SvgPicture.asset(
                            isEdit ? AppAssets.checkBlue : AppAssets.pencil),
                      ),
                      onTap: () async {
                        //delay to give ripple effect
                        await Future.delayed(
                            Duration(milliseconds: AppStrings.delay));
                        if (isEdit) {
                          _updateProfile();
                        } else {
                          isEdit = !isEdit;
                          _notify();
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          textfield(
            controller: _usernameController,
            icon: AppAssets.drawerMyProfile,
            enabled: isEdit,
          ),
          textfield(
            controller: _emailController,
            icon: AppAssets.email,
            enabled:
                customer.facebookId.length != 0 || customer.googleId.length != 0
                    ? false
                    : isEdit,
          ),
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              if (isEdit) {
                maleFemale = maleFemale == AppStrings.male
                    ? AppStrings.female
                    : AppStrings.male;
                _notify();
              }
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    height: 17,
                    width: 17,
                    child: SvgPicture.asset(AppAssets.gender),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    maleFemale == AppStrings.male
                        ? "Male"
                        : maleFemale == AppStrings.female
                            ? "Female"
                            : isEdit
                                ? "Tap to change"
                                : "",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              if (isEdit) {
                _selectDate();
              }
            },
            child: Container(
              child: Row(
                children: [
                  Container(
                    height: 17,
                    width: 17,
                    child: SvgPicture.asset(AppAssets.birthday),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Text(
                    dob == "" && isEdit ? "Tap to change" : getDob(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateProfilePicture() async {
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //headers
      var headers = Map<String, String>();
      headers["Accept"] = "application/json";
      if (Utility.getCustomer() != null) {
        headers["Authorization"] = Utility.getCustomer().token;
      }
      //api request
      var uri = Uri.parse(AppStrings.customerUpdate);
      var request = MultipartRequest('PUT', uri);
      request.headers.addAll(headers);
      request.fields["id"] = customer.id.toString();
      if (_image != null) {
        request.files.add(
          await MultipartFile.fromPath(
            'userProfileImage',
            _image.path,
            contentType: MediaType('image', _image.path.split(".").last),
          ),
        );
      }
      //api call
      Response response = await Response.fromStream(await request.send());
      //hide progress
      _isLoading = false;
      _notify();
      print(response.body);
      if (response.statusCode == 200) {
        UserResponse userResponse =
            UserResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(context, userResponse.message);
        Customer tempCustomer = userResponse.result;
        tempCustomer.token = customer.token;
        await PreferenceUtils.setString(
            AppStrings.userPreference, jsonEncode(tempCustomer.toJson()));
        customer = Utility.getCustomer();
        _notify();
      } else {
        CommonResponse commonResponse =
            CommonResponse.fromJson(jsonDecode(response.body));
        Utility.showToast(context, commonResponse.message);
      }
    } else {
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  _updateProfile() {
    if (_emailController.text.trim() != "" &&
        !Utility.isValidEmail(_emailController.text.trim())) {
      Utility.showToast(context, "Invalid email");
    } else if (_phoneController.text.trim() != "" &&
        _phoneController.text.trim().length != 10) {
      Utility.showToast(context, "Phone number must be 10 digits");
    } else {
      updateProfile();
    }
  }

  updateProfile() async {
    isEdit = !isEdit;
    _notify();
    //check internet connection available or not
    if (await ApiManager.checkInternet()) {
      //show progress
      _isLoading = true;
      _notify();
      //api request
      var request = Map<String, dynamic>();
      request["id"] = customer.id.toString();
      if (_usernameController.text.trim() != "")
        request["username"] = _usernameController.text.trim();
      if (_emailController.text.trim() != "" &&
          _emailController.text.trim() != customer.email)
        request["email"] = _emailController.text.trim();
      if (_phoneController.text.trim() != "" &&
          _phoneController.text.trim() != customer.phoneNumber)
        request["phoneNumber"] = _phoneController.text.trim();
      if (maleFemale != -1) request["gender"] = maleFemale.toString();
      if (dob != "") request["dob"] = dob;
      //api call
      UserResponse response = UserResponse.fromJson(
        await ApiManager(context)
            .putCall(url: AppStrings.customerUpdate, request: request),
      );
      //hide progress
      _isLoading = false;
      _notify();

      Utility.showToast(context, response.message);

      if (response.code == 200) {
        Customer tempCustomer = response.result;
        tempCustomer.token = customer.token;
        await PreferenceUtils.setString(
            AppStrings.userPreference, jsonEncode(tempCustomer.toJson()));
        customer = Utility.getCustomer();
        _notify();
      } else {
        init();
      }
    } else {
      //show message that internet is not available
      Utility.showToast(context, AppStrings.noInternet);
    }
  }

  String getDob() {
    try {
      return dob == "" ? dob : Utility.convertDate(dob);
    } catch (e) {
      return "";
    }
  }

  _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 25),
        lastDate: DateTime.now());
    dob = "${picked.year}-${picked.month}-${picked.day}";
    _notify();
  }

  Widget textfield({
    @required TextEditingController controller,
    @required String icon,
    @required bool enabled,
    int maxLength,
  }) {
    return Row(
      children: [
        Container(
          height: 17,
          width: 17,
          child: SvgPicture.asset(icon),
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
              border: enabled ? null : InputBorder.none,
            ),
            maxLength: maxLength,
          ),
        ),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }

  Widget accountDetailsView() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              right: 4,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Account Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Container(
                        height: 15,
                        width: 15,
                        margin: EdgeInsets.all(16),
                        child: SvgPicture.asset(
                            isEdit ? AppAssets.checkBlue : AppAssets.pencil),
                      ),
                      onTap: () async {
                        //delay to give ripple effect
                        await Future.delayed(
                            Duration(milliseconds: AppStrings.delay));
                        if (isEdit) {
                          _updateProfile();
                        } else {
                          isEdit = !isEdit;
                          _notify();
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          textfield(
            controller: _phoneController,
            icon: AppAssets.mobile,
            enabled: isEdit,
            maxLength: 10,
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Stack(
      children: [
        Utility.profileTopView(
          context,
          assetName: AppAssets.profileTopBg,
        ),
        Container(
          padding: MediaQuery.of(context).padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              userImage(),
              SizedBox(
                height: 8,
              ),
              nameClassView(),
              // Utility.leaderBoardView(),
              SizedBox(
                height: 16,
              ),
              bottomView(),
            ],
          ),
        ),
        _isLoading ? Utility.progress(context) : Container(),
      ],
    );
  }

  Widget bottomView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              accountDetailsView(),
              profileDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameClassView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Utility.getUsername(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeGradeScreen(
                  isFirstTime: false,
                ),
              ),
            );
            _getUser();
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.class1,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  customer.classGrades.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  onPressed: null,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  dummyUserView(double size) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.appColor,
          width: 2,
        ),
      ),
      height: size,
      width: size,
      child: Icon(
        Icons.person,
        color: AppColors.appColor,
        size: size / 1.5,
      ),
    );
  }

  Widget userImage() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        customer == null
            ? dummyUserView((MediaQuery.of(context).size.height / 3.5) / 2)
            : customer.thumbnail == ""
                ? dummyUserView((MediaQuery.of(context).size.height / 3.5) / 2)
                : _image == null
                    ? Utility.getUserImage(
                        url: customer.thumbnail,
                        height: (MediaQuery.of(context).size.height / 3.5) / 2,
                        width: (MediaQuery.of(context).size.height / 3.5) / 2,
                        borderRadius: MediaQuery.of(context).size.height,
                      )
                    : Container(
                        height: (MediaQuery.of(context).size.height / 3.5) / 2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.appColor,
                            width: 2,
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              _image,
                            ),
                          ),
                        ),
                      ),
        Positioned(
          right: 10,
          child: GestureDetector(
            onTap: () {
              _onProfilePicTap();
            },
            child: Container(
              height: 35,
              width: 35,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.myProgressIncorrectcolor,
                  width: 2,
                ),
              ),
              child: SvgPicture.asset(
                AppAssets.pencil,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _onProfilePicTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text("Select Profile Picture"),
          message: Text("Select from"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
              child: Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
              child: Text("Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        );
      },
    );
  }

  _getImage(ImageSource source) async {
    _picker.getImage(source: source).then((value) {
      if (value != null) {
        _image = File(value.path);
        _notify();
        _cropImage();
      } else {
        print('No image selected.');
      }
      _notify();
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 80,
        cropStyle: CropStyle.circle,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.appColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      _notify();
      _updateProfilePicture();
    }
  }
}
