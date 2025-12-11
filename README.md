1. When the puzzle is solved the lines disappear and the puzzle appear whole

2. Multiplayer: A player can invite someone else to compete in putting together a puzzle. So both should be playing same puzzle at their end and if anyone completes it first will be the winner




Make profile image optional


   // Avatar
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: AppColors.logoGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      name[0],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
