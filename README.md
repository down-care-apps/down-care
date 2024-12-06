# Down Care

**Project Title**: DownCare App  
**Type**: Project-Based Learning  

---

## **Overview**  

The DownCare App is a user-friendly application designed to assist parents in monitoring their children's growth and detecting early signs of Down Syndrome through machine learning and facial analysis. This backend repository provides the core APIs and services for managing child profiles, scanning history, and user authentication.  

---

## **Key Features**  

- **Child Profile Management**:  
  Add, update, and manage your children's profiles, including details such as name, age, gender, weight, height, and date of birth.  

- **Down Syndrome Detection**:  
  Upload a child’s photo for facial analysis using Machine Learning to detect potential markers of Down Syndrome, with results displayed in an easy-to-understand format.  

- **Scan History**:  
  View the history of scans and results to monitor your child’s development and track progress over time.  

- **Progress Tracker**:  
  Track your child’s growth metrics, such as weight and height, over time and compare them to standard growth charts.  

- **Reminders**:  
  Set reminders for important activities, such as doctor appointments, therapy sessions, or medication schedules, ensuring you never miss a critical event.  

- **Maps Integration**:  
  Locate nearby hospitals and healthcare facilities specializing in Down Syndrome care, providing convenience during emergencies or routine check-ups.  

- **Articles**:  
  Access a curated library of articles and resources related to Down Syndrome to stay informed about your child’s condition and care options.  

---

## **Technologies Used**  

- **Flutter**: For the frontend application interface, ensuring a smooth and responsive user experience.  
- **Firebase**  
  Firebase serves as the core backend technology for this application, offering seamless integration and scalability:  
  - **Firebase Authentication**: Securely manages user sign-up, login, and session handling.  
  - **Firebase Firestore**: A real-time NoSQL database used to store and manage child profiles, scan histories, reminders, and articles.  
  - **Firebase Storage**: Reliable storage for uploaded media files, such as photos used in the Down Syndrome detection feature.
- **Node.js with Express.js**: Serves as the backend framework for API development.  
- **Flask**: Flask is used to build the backend for image analysis, processing photos for Down Syndrome detection using machine learning algorithms.

---

## **Contributors**

- **Cinthya Achwatul Ifnu** - Front-end Developer  
- **Doni Wahyu Kurniawan** - Front-end Developer, Machine Learning Engineer
- **Halur Muhammad Abiyyu** - Back-end Developer  
- **Muhammad Iqbal Makmur** - Back-end Developer

## Kontribusi Anggota Kelompok

- **Cinthya Achwatul Ifnu**
    1. Membuat tampilan front-end untuk admin berbasis web web untuk CRUD akun dan artikel
    2. Design UI aplikasi mobile

- **Doni Wahyu Kurniawan**
    1. Membuat tampilan front-end untuk login, register, halaman utama, menu maps, menu reminder, menu list artikel, tiap sub menu pada menu pengaturan, implementasi kamera, implementasi upload gambar, halaman loading analisis, hasil analisis, halaman riwayat, halaman detail riwayat.
    2. Membuat model user, children, dan scan history
    3. Membuat state management pada user, children, dan scan history
    4. Membuat model ML yang akan digunakan untuk analisa di aplikasi mobile
    5. Design UI aplikasi mobile

- **Halur Muhammad Abiyyu**
    1. Membuat tampilan front-end untuk halaman daftar profil anak, tambah profil anak, edit profil anak, hapus profil anak.
    2. Membuat REST API dengan expressJS untuk menghubungkan semua fitur pada aplikasi mobile dengan Firebase.
    3. Membuat autentikasi login menggunakan email dan password serta login dengan google melalui Firebase.
    4. Melakukan fetching data dari REST API pada semua fitur aplikasi mobile
    5. Hosting ML model untuk mencari hasil analisis di mobile

- **Muhammad Iqbal Makmur**
    1. Membuat tampilan front-end progress tracker, halaman detail artikel
    2. Membuat logika CRUD untuk tampilan admin berbasis web
    3. Design UI aplikasi mobile
