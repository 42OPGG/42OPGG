import React, { useState, useEffect } from 'react'
import Axios from 'axios'

function CorrectorPage(props) {
    
    const login = props.match.params.login
    const [Corrector, setCorrector] = useState(null)
    
    useEffect(() => {
        Axios.get(`/api/corrector/${login}/15`)
            .then(response => {
                if(response.data.success) {
                    setCorrector(response.data.data)
                }
            })
        }, [])
    


    return (
        <div style={{ width: '100%', margin: '0' }}>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>

                <h1>corrector</h1>
                <hr/>
                {Corrector && Corrector.map((comment, index) => (
                    <div key={index} style={{ width: '80%' }}>
                        <h3>{login} : {comment.comment}</h3>
                        <h3>상대방 : {comment.feedback}</h3>
                        <hr/>
                    </div>

                ))
                }
                {Corrector ? <div/>:<h1>loading...</h1>}
            </div>
        </div>
    )
}

export default CorrectorPage
