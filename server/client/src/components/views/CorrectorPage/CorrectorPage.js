import React, { useState, useEffect } from 'react'

function CorrectorPage() {
    
    const [Corrector, setCorrector] = useState([])
    
    useEffect(() => {
        Axios.get(`/api/corrector/${login}/15`)
            .then(response => {
                if(response.data.success) {
                    setCorrector(response.data.data)
                }
            })
        })
    


    return (
        <div style={{ width: '100%', margin: '0' }}>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>

                <h1>corrector</h1>
                {Corrector && Corrector.map((comment, index) => (
                    <div key={index}>
                        <h3>{login} : {comment.comment}</h3>
                        <h3>상대방 : {comment.feedback}</h3>
                    </div>
                ))
                }
            </div>
        </div>
    )
}

export default CorrectorPage
