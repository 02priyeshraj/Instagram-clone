import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firebase_services/firestore.dart';
import 'package:instagram_clone/resources/model/user.dart';
import 'package:instagram_clone/resources/providers/user_provider.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimatingValue = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: primaryColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0,
            ).copyWith(right: 0.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.0,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.snap['location'] ?? '',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: loginTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map(
                                    (e) => InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () async {
                                          FireStoreMethods().deletePost(
                                              widget.snap['postId']);

                                          Navigator.of(context).pop();
                                        }),
                                  )
                                  .toList()),
                        );
                      },
                    );
                  }, // Add a dialog box
                  icon: const Icon(
                    Icons.more_horiz,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimatingValue = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimatingValue ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimatingValue,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimatingValue = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: primaryColor,
                      size: 125,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 8.0,
                ),
                child: LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: GestureDetector(
                    onTap: () async {
                      await FireStoreMethods().likePost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    child: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: likeColor,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.7,
                        maxChildSize: 0.9,
                        minChildSize: 0.4,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0),
                              ),
                            ),
                            child: CommentsScreen(
                              snap: widget.snap,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/Icons/comment.webp',
                    height: 24.0,
                    width: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/Icons/send.png',
                    height: 20.0,
                    width: 20.0,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length} likes',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 6.0,
                  ),
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: '  ',
                        ),
                        TextSpan(
                          text: widget.snap['caption'],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.snap['postId'])
                          .collection('comments')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            'Loading comments...',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: secondaryColor,
                            ),
                          );
                        }
                        int commentCount = snapshot.data?.docs.length ?? 0;
                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.7,
                                maxChildSize: 0.9,
                                minChildSize: 0.4,
                                builder: (context, scrollController) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16.0),
                                      ),
                                    ),
                                    child: CommentsScreen(
                                      snap: widget.snap,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            'View all $commentCount comments',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: secondaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
