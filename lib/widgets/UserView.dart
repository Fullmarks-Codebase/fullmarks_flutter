import 'package:flutter/material.dart';
import 'package:fullmarks/models/DiscussionResponse.dart';
import 'package:fullmarks/utility/AppAssets.dart';
import 'package:fullmarks/utility/AppColors.dart';
import 'package:fullmarks/utility/AppStrings.dart';
import 'package:fullmarks/utility/Utiity.dart';

class UserView extends StatefulWidget {
  Function onUserTap;
  DiscussionDetails discussion;
  UserView({
    @required this.onUserTap,
    @required this.discussion,
  });
  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onUserTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          right: 16,
          left: 16,
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 16,
                bottom: 16,
                right: 16,
              ),
              child: Utility.getUserImage(
                url: widget.discussion.user.thumbnail,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.discussion.user.username.trim().length == 0
                              ? "User" + widget.discussion.user.id.toString()
                              : widget.discussion.user.username,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        Utility.convertDate(
                            widget.discussion.createdAt.substring(0, 10)),
                        style: TextStyle(
                          color: AppColors.lightTextColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 12,
                        child: Utility.imageLoader(
                          baseUrl: AppStrings.subjectImage,
                          url: widget.discussion.subject.image,
                          placeholder: AppAssets.subjectPlaceholder,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.discussion.subject.name,
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
