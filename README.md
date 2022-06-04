Flutter Project

**Attendance System Using Face Recognition.**


Attendance Tracker is an application that takes attendance through face recognition and maintains the attendance records for each month. It also keeps records of personal details and the percentage of attendance for each month of a particular student. The Teacher will be able to see the attendance records and student records for each class through the application itself. The teacher needs to create an account and sign in using their email and password.

**Technology/Database Used:**

Flutter - Used to make the Application

Dart - Programming language used for backend

Tensorflow lite - Used to detect and recognize faces

Firebase Database - Used to Store the Attendance and Student Records 


**Preview of the App: **

Add New Student:

<img src= https://user-images.githubusercontent.com/84145871/171986056-09b4c3d0-ff57-49b0-937e-d0ef8e42b2af.jpeg height="300"/>  <img src= https://user-images.githubusercontent.com/84145871/171986107-30546af9-917a-46ef-828c-d92106f2c450.jpeg height="300"/>  <img src=https://user-images.githubusercontent.com/84145871/171986551-326736f7-3ce3-49ee-9990-44e134216d7b.jpeg height="300"/>

Take Attendance:

<img src=https://user-images.githubusercontent.com/84145871/171986596-3d9dfd3d-b2f2-4ac7-b9a6-5f714c952115.jpeg height="300" />  <img src=https://user-images.githubusercontent.com/84145871/171986602-a67fe128-b5a8-4bcb-9eb7-9f400a74e0a7.jpeg height="300" />

Classroom:


<img src=https://user-images.githubusercontent.com/84145871/171987756-8f7da570-e23d-4053-b488-c552bde737b7.jpeg  height="300"/>  <img src=https://user-images.githubusercontent.com/84145871/171987928-2afd316a-7d8f-4d1b-93f7-9c209c620802.jpeg height="300" /> <img src=https://user-images.githubusercontent.com/84145871/171986622-8bd0821b-a001-49e2-b542-9c19d1afb2d6.jpeg height="300"/> <img src=https://user-images.githubusercontent.com/84145871/171986635-284b9179-e85e-4231-ae71-938aba2ec767.jpeg  height="300"/> <img src=https://user-images.githubusercontent.com/84145871/171986639-7ca540f6-113d-443a-a1ea-9165e8f88b45.jpeg height="300"/>

Attendance Records for each day:

<img src=https://user-images.githubusercontent.com/84145871/171986643-2889deaf-2cd0-424a-b28d-b7713ddfc81c.jpeg height="300" /> <img src=https://user-images.githubusercontent.com/84145871/171986648-0c4c270a-05c3-412f-85ce-01946bbeab37.jpeg height="300" /> <img src=https://user-images.githubusercontent.com/84145871/171986654-42f62d5e-42aa-42dc-9e93-1f7615afb80f.jpeg height="300" />


**Model used for Face Detection: **

Face Detection is done through the google ml kit provided by Flutter which uses the HAAR cascade algorithm for face detection.

Face Recognition is done through the TensorFlow model. 
TensorFlow Lite is a set of tools that enables on-device machine learning by helping developers run their models on mobile, embedded, and edge devices.

The TFlite uses the MTCNN algorithm for face detection and recognition. 

Multi-task Cascaded Convolutional Networks (MTCNN) is a framework developed as a solution for both face detection and face alignment. The process consists of three stages of convolutional networks that are able to recognize faces and landmark locations such as eyes, nose, and mouth.


