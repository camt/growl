FasdUAS 1.101.10   ��   ��    l    p ��  O     p    k    o     	  l   ������  ��   	  
  
 l   �� ��    P J this script offers rudimentary use of Growl: [url]http://growl.info[/url]         l   �� ��    6 0 At the time of writing, Growl is at version 0.5         l   �� ��    W Q See the site for more info about Growl, the global notification system for OS X.         l   �� ��    o i Cobbled together by Robert Black ([url]http://www.robertblack.com.au[/url]), based on an example script          l   �� ��      included with PowerMail.         l   ������  ��        l   �� ��    8 2 PowerMail info: [url]http://www.ctmdev.com/[/url]         l   ������  ��       !   l   ������  ��   !  " # " l   �� $��   $ n h To use this script, you must first have Growl installed. See [url]http://growl.info/downloads.php[/url]    #  % & % l   �� '��   ' Q K Next, copy this script to ~/Mail/PowerMail Files/Custom Scripts/Growl.scpt    &  ( ) ( l   �� *��   * b \ Then in PowerMail set up a Filter with an "Execute AppleScript" action, and choose "Growl"     )  + , + l   �� -��   - K E If "Growl" isn't in the list of scripts, quit and relaunch PowerMail    ,  . / . l   ������  ��   /  0 1 0 l   �� 2��   2 _ Y Now, when one or more emails arrive, which match your filter's "Conditions", Growl will     1  3 4 3 l   �� 5��   5 @ : display the Sender and Subject of the first email to you.    4  6 7 6 l   ������  ��   7  8 9 8 r    	 : ; : 1    ��
�� 
CMgs ; o      ���� 0 themessages theMessages 9  < = < Z   
  > ?���� > =  
  @ A @ l  
  B�� B n   
  C D C m    ��
�� 
nmbr D n   
  E F E 2   ��
�� 
cobj F o   
 ���� 0 themessages theMessages��   A m    ����   ? I   �� G��
�� .sysodlogaskr        TEXT G m     H H 5 /Error - This is meant to be called by a filter.   ��  ��  ��   =  I J I l   ������  ��   J  K L K r    ! M N M m    ��
�� boovtrue N o      ���� 0 	fl_simple 	fl_Simple L  O P O l  " "�� Q��   Q h b In my experience it's not a good idea to repeat this if multiple emails arrive at the same time,     P  R S R l  " "�� T��   T Z T since the notifications are sequential, but the code's here if you want to try it.     S  U V U l  " "�� W��   W . ( Just change to "set fl_Simple to false"    V  X Y X l  " "������  ��   Y  Z [ Z l  " "������  ��   [  \ ] \ X   " m ^�� _ ^ k   2 h ` `  a b a r   2 7 c d c n   2 5 e f e 1   3 5��
�� 
subj f o   2 3���� 0 msg   d o      ���� 0 s   b  g h g r   8 = i j i n   8 ; k l k 1   9 ;��
�� 
sndr l o   8 9���� 0 msg   j o      ���� 0 f   h  m n m r   > C o p o n   > A q r q 1   ? A��
�� 
dspn r o   > ?���� 0 f   p o      ���� 0 f   n  s t s O   D ^ u v u I  H ]���� w
�� .notifygrnull��� ��� null��   w �� x y
�� 
titl x o   L M���� 0 f   y �� z {
�� 
desc z o   P Q���� 0 s   { �� |��
�� 
iapp | m   T W } }  PowerMail.app   ��   v m   D E ~ ~Fnull     ߀��  #gGrowlHelperApp.appame time, [/url]   ����    :   �����GRRR   alis    �  kremit                     ��=)H+    #gGrowlHelperApp.app                                               #����        ����  	                	Resources     �Ãy      ���l      #g  #c  #b �� �P �O  |  _kremit:Users:chris:Library:PreferencePanes:Growl.prefPane:Contents:Resources:GrowlHelperApp.app   &  G r o w l H e l p e r A p p . a p p    k r e m i t  XUsers/chris/Library/PreferencePanes/Growl.prefPane/Contents/Resources/GrowlHelperApp.app  /    ��   t  ��  Z   _ h � ����� � o   _ `���� 0 	fl_simple 	fl_Simple � l  c d � � �  S   c d � &   run only with the first message   ��  ��  ��  �� 0 msg   _ o   % &���� 0 themessages theMessages ]  ��� � l  n n������  ��  ��    m      � ��null     ߀��  BPowerMail.app� �0    ��� ŉР �0                 ���(.���@��Cmlt   alis    n  kremit                     ��=)H+    BPowerMail.app                                                    B�yc�        ����  	                PowerMail 5.0.2     �Ãy      �y�N      B  ^  1kremit:Applications:PowerMail 5.0.2:PowerMail.app     P o w e r M a i l . a p p    k r e m i t  *Applications/PowerMail 5.0.2/PowerMail.app  / ��  ��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     p � �  ����  ��  ��   � ���� 0 msg   �  ��������� H������������������ ~������ }����
�� 
CMgs�� 0 themessages theMessages
�� 
cobj
�� 
nmbr
�� .sysodlogaskr        TEXT�� 0 	fl_simple 	fl_Simple
�� 
kocl
�� .corecnte****       ****
�� 
subj�� 0 s  
�� 
sndr�� 0 f  
�� 
dspn
�� 
titl
�� 
desc
�� 
iapp�� 
�� .notifygrnull��� ��� null�� q� m*�,E�O��-�,j  
�j Y hOeE�O J�[��l 	kh  ��,E�O��,E�O��,E�O� *a �a �a a a  UO� Y h[OY��OPU ascr  ��ޭ