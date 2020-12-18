import React from 'react';
import RightMenu from './Sections/RightMenu';
import './Sections/Navbar.css'

function NavBar() {
    return (
        <nav className="menu" style={{ position: 'fixed', zIndex: 5, width: '100%' }}>
            <div className="menu__logo">
                <a href="/">OP_GG</a>
            </div>
            <div className="menu__container">
                <div className="menu_right" style={{ display: 'flex', flexDirection: 'row', alignContent:'center', marginTop: '1rem' }}>
                    <RightMenu mode="horizontal" />
                </div>
            </div>
        </nav>
    )
}

export default NavBar
