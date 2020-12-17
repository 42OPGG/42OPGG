import React, { useEffect, useState } from 'react'
import { withRouter } from 'react-router-dom'
import Axios from 'axios'


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
        <div style={{ width: '100%', margin: '0' }}>
            <div>
                <textarea onChange={onLoginChange} value={Login}></textarea>
                <button onClick={onButtonClick}>GG</button>
            </div>
        </div>
        
    )
}

export default withRouter(LandingPage)
