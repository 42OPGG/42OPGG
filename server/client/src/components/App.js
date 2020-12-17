import React, { Suspense } from 'react'
import {
  BrowserRouter as Router,
  Route,
  Switch } from "react-router-dom"
import LandingPage from "./views/LandingPage/LandingPage.js";
import mainPage from "./views/mainPage/mainPage.js"

// import Footer from "./views/Footer/Footer";

function App() {
  return (
    <Router fallback={(<div>Loading...</div>)}>
      <div style={{ paddingTop: '69px', minHeight: 'calc(100vh - 80px)' }}>
        <Switch>
          <Route exact path="/" component={LandingPage} />
          <Route exact path="/main/:login" component={mainPage} />
        </Switch>
      </div>
      {/* <Footer /> */}
    </Router>
  );
}

export default App;
