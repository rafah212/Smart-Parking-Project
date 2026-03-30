import 'package:flutter/material.dart';
import '../../core/widgets/responsive_preview.dart';

class Page1Screen extends StatelessWidget {
  const Page1Screen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsivePreview(
    child: SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
     // body: Center(
      //  child: /* هنا الـ Container اللي كان عندك */
        

Container(
  width: 375,
  height: 812,
  clipBehavior: Clip.antiAlias,
  decoration: ShapeDecoration(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),


  child: Stack(
    children: [
      Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: 375,
          height: 812,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white.withValues(alpha: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
      

          child: Stack(
            children: [
              Positioned(
                left: -21,
                top: -19,
                child: Container(
                  width: 430,
                  height: 850,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.10, 0.08),
                      end: Alignment(0.91, 0.87),
                      colors: [const Color(0xFF45B8CB), const Color(0xFF0E3339)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
          

              Positioned(
                left: 301,
                top: 763,
                child: Container(
                  width: 65,
                  height: 27,
                  decoration: ShapeDecoration(
                    color: const Color(0x00FF6768),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            

              Positioned(
                left: 312,
                top: 766,
                child: SizedBox(
                  width: 44,
                  height: 22.85,
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF2E4154),
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),


              Positioned(
                left: 147,
                top: 772,
                child: Container(
                  width: 40,
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF72ACB6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),


              Positioned(
                left: 197,
                top: 771,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: ShapeDecoration(
                    color: const Color(0xB23A455D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),


              Positioned(
                left: 217,
                top: 771,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: ShapeDecoration(
                    color: const Color(0xB23A455D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),


              Positioned(
                left: 17,
                top: 45,
                child: SizedBox(
                  width: 341,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 275,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '1',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '/3',
                              style: TextStyle(
                                color: const Color(0x7F0F3339),
                                fontSize: 18,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


      Positioned(
        left: -6,
        top: 450,
        child: SizedBox(
          width: 372,
          height: 812,
          child: Text(
            'Find the nearest\nparking spot',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF181E2E),
              fontSize: 25,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),


      Positioned(
        left: -6,
        top: 556,
        child: SizedBox(
          width: 372,
          height: 812,
          child: Text(
            'Locate available spots instantly\nwherever you are',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.04,
            ),
          ),
        ),
      ),
      
      
      Positioned(
          left: 0,
          top: 300,
          right: 0,
          child: Center(
          child: Image.asset(
            'assets/images/page1.png',
             width: MediaQuery.of(context).size.width * 0.6, // تحكم بالحجم هنا
             height: MediaQuery.of(context).size.height * 0.18,
             fit: BoxFit.contain,
          ),
         ),
        ),
       ],
      ),
     ),
    ],
   ),
  ),
),
);
}
}