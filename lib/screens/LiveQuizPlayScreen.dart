import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fullmarks/screens/RankListScreen.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/Utiity.dart';

class LiveQuizPlayScreen extends StatefulWidget {
  bool isRandomQuiz;
  LiveQuizPlayScreen({
    @required this.isRandomQuiz,
  });
  @override
  _LiveQuizPlayScreenState createState() => _LiveQuizPlayScreenState();
}

class _LiveQuizPlayScreenState extends State<LiveQuizPlayScreen> {
  int perQuestionSeconds = 5;
  int totalQuestion = 5;
  int currentQuestion = 0;
  int selectedAnswer = -1;

  //after user selects answer, when time ends then show answer is correct or incorrect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Utility.setSvgFullScreen(context, AppAssets.mockTestBg),
          Column(
            children: [
              Spacer(),
              SvgPicture.asset(
                AppAssets.bottomBarbg,
                width: MediaQuery.of(context).size.width,
              )
            ],
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 16,
              ),
              participantsView(),
              SizedBox(
                width: 4,
              ),
              timerView(),
              SizedBox(
                width: 4,
              ),
              scoreView(),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          questionAnswerItemView(),
        ],
      ),
    );
  }

  Widget questionAnswerItemView() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          right: 16,
          left: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                right: 16,
                left: 16,
                top: 16,
              ),
              child: Text(
                "Question " +
                    (currentQuestion + 1).toString() +
                    " / " +
                    totalQuestion.toString(),
                style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Divider(
                thickness: 2,
              ),
            ),
            questionText(),
            currentQuestion % 2 == 0 ? questionImageView() : Container(),
            SizedBox(
              height: 16,
            ),
            answersView()
          ],
        ),
      ),
    );
  }

  Widget questionText() {
    return Container(
      padding: EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      child: Text(
        "Which one of the following has maximum number of atoms?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget answersView() {
    return Column(
      children: List.generate(4, (index) {
        return (currentQuestion - 1) % 4 == 0
            ? imageAnswerItemView(index)
            : textAnswerItemView(index);
      }),
    );
  }

  Widget imageAnswerItemView(int index) {
    return GestureDetector(
      onTap: () {
        if (mounted)
          setState(() {
            selectedAnswer = index;
          });
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedAnswer == index
                ? AppColors.myProgressIncorrectcolor
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Image.asset(
              index == 0
                  ? AppAssets.answerImage1
                  : index == 1
                      ? AppAssets.answerImage2
                      : index == 2
                          ? AppAssets.answerImage3
                          : AppAssets.answerImage4,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1,
                    color: Colors.black38,
                  ),
                ],
              ),
              child: Text(
                index == 0
                    ? "(A)"
                    : index == 1
                        ? "(B)"
                        : index == 2
                            ? "(C)"
                            : "(D)",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textAnswerItemView(int index) {
    return GestureDetector(
      onTap: () {
        if (mounted)
          setState(() {
            selectedAnswer = index;
          });

        if (index == 0) {
          Utility.showAnswerToast(context, "Correct", AppColors.correctColor);
        } else if (index == 1) {
          Utility.showAnswerToast(
              context, "Incorrect", AppColors.incorrectColor);
        } else if (index == 3) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => RankListScreen(
                isRandomQuiz: widget.isRandomQuiz,
                title: widget.isRandomQuiz ? "Live Quiz Result" : "Rank List",
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: 16,
          right: 16,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
        alignment: Alignment.center,
        decoration: selectedAnswer == index
            ? Utility.selectedAnswerDecoration(
                color: index == 0
                    ? AppColors.strongCyan
                    : index == 1
                        ? AppColors.wrongBorderColor
                        : AppColors.myProgressIncorrectcolor,
              )
            : selectedAnswer == 1 && index == 2
                ? Utility.selectedAnswerDecoration(color: AppColors.strongCyan)
                : Utility.defaultAnswerDecoration(),
        child: Text(
          index == 0
              ? "(A) Correct Answer"
              : index == 1
                  ? "(B) Wrong Answer"
                  : index == 2
                      ? "(C) Answer Selection"
                      : "(D) Goto next",
          style: TextStyle(
            color: selectedAnswer == index
                ? Colors.white
                : selectedAnswer == 1 && index == 2
                    ? Colors.white
                    : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget questionImageView() {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      child: Image.asset(
        AppAssets.dummyQuestionImage,
      ),
    );
  }

  Widget scoreView() {
    return Expanded(
      flex: 20,
      child: widget.isRandomQuiz
          ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Adit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "5",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(AppAssets.dummyUser),
                      ),
                      border: Border.all(
                        color: AppColors.myProgressIncorrectcolor,
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "My Score : 5",
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.appColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget timerView() {
    return Expanded(
      flex: 12,
      child: Container(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.myProgressIncorrectcolor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets.whiteClock,
                color: AppColors.appColor,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                perQuestionSeconds.toString(),
                style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget participantsView() {
    return Expanded(
      flex: 20,
      child: widget.isRandomQuiz
          ? Container(
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(AppAssets.dummyUser),
                      ),
                      border: Border.all(
                        color: AppColors.myProgressIncorrectcolor,
                        width: 2,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amit",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  showParticipantsDialog();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        child: SvgPicture.asset(
                          AppAssets.participants,
                          color: AppColors.appColor,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Participants (15)",
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.appColor,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.appColor,
                        size: 12,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  showParticipantsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Participants (7)",
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: AppColors.greyColor4,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return participantsItemView(index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget participantsItemView(int index) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(AppAssets.dummyUser),
          ),
        ),
      ),
      title: Text(
        'User Name',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Container(
        margin: EdgeInsets.only(
          right: 4,
        ),
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
              offset: Offset(1, 0),
            ),
          ],
        ),
        child: Text(
          "Score : 5",
          style: TextStyle(
            fontSize: 12,
            color: AppColors.appColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
