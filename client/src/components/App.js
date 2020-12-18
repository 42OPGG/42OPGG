import React, { Suspense } from 'react'
import {
  BrowserRouter as Router,
  Route,
  Switch } from "react-router-dom"
import LandingPage from "./views/LandingPage/LandingPage.js";
import mainPage from "./views/mainPage/MainPage.js";
import CorrectorPage from './views/CorrectorPage/CorrectorPage.js';
import CorrectedPage from './views/CorrectedPage/CorrectedPage.js';

import NavBar from './views/NavBar/NavBar.js'
// import Footer from "./views/Footer/Footer";

function App() {
  return (
    <Router fallback={(<div>Loading...</div>)}>
      <NavBar/>
      <div style={{ paddingTop: '69px', minHeight: 'calc(100vh - 80px)' }}>
        <Switch>
          <Route exact path="/" component={LandingPage} />
          <Route exact path="/main/:login" component={mainPage} />
          <Route exact path="/corrector/:login" component={CorrectorPage} />
          <Route exact path="/corrected/:login" component={CorrectedPage} />
        </Switch>
      </div>
      {/* <Footer /> */}
    </Router>
  );
}

export default App;
