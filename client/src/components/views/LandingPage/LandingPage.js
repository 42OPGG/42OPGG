import React, { useEffect, useState } from 'react'
import { withRouter } from 'react-router-dom'
import Axios from 'axios'
import logo from '../../../logo.png'


function LandingPage(props) {

    const [Login, setLogin] = useState('')

    useEffect(() => {
    }, [])

    const onLoginChange = (e) => {
        setLogin(e.currentTarget.value)
    }
    
    const onButtonClick = (e) => {
        e.preventDefault();
        props.history.push(`/main/${Login}`)
    }

    return (
        <div style={{ display: 'flex', width: '100%', marginTop: '3rem', justifyContent:'center', flexDirection: 'column', alignItems: 'center' }}>
            <div>
                <img src={logo} style={{ display: 'flex' }}></img>
            </div>
            <div style={{ display: 'flex', width: '50%', marginTop: '3rem' }}>
                <textarea style={{ width: '80%', height: '50px', marginRight: '2rem', textAlign:'center' }} onChange={onLoginChange} value={Login}></textarea>
                <button style={{ width: '15%', height: '50px' }} onClick={onButtonClick}>GG</button>
            </div>
        </div>
        
    )
}

export default withRouter(LandingPage)
