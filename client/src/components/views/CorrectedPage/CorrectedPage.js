import React, { useState, useEffect } from 'react'
import Axios from 'axios'

function CorrectedPage(props) {
    
    const login = props.match.params.login
    const [Corrected, setCorrected] = useState(null)
    
    useEffect(() => {
        Axios.get(`/api/corrected/${login}/15`)
            .then(response => {
                if(response.data.success) {
                    setCorrected(response.data.data)
                }
            })
        }, [])

        console.log(Corrected)

    return (
        <div style={{ width: '100%', margin: '0' }}>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>

                <h1>corrected</h1>
                <hr/>
                {Corrected && Corrected.map((comment, index) => (
                    <div key={index} style={{ width: '80%' }}>
                        <h3>상대방 : {comment.comment}</h3>
                        <h3>{login} : {comment.feedback}</h3>
                        <hr/>
                    </div>

                ))
                }
                {Corrected ? <div/>:<h1>loading...</h1>}
            </div>
        </div>
    )
}

export default CorrectedPage
