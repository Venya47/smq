// firebase-config.js
import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: "AIzaSyAw2eZ6o4J8HCR8LL2Aw0tuI-Hj8pHfits",
  authDomain: "ee-smq.firebaseapp.com",
  projectId: "ee-smq",
  storageBucket: "ee-smq.appspot.com",
  messagingSenderId: "433562558275",
  appId: "1:433562558275:web:388dbd805c4193e5bd9d9f6",
  measurementId: "G-RH4K2SBZYT"
};

const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
