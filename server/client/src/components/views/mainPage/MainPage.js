import React, { useEffect, useState } from 'react'
import { withRouter } from 'react-router-dom'
import Axios from 'axios'


function MainPage(props) {

    const login = props.match.params.login
    const [Subject, setSubject] = useState([])
    const [PiscineLevel, setPiscineLevel] = useState(null)
    const [PiscineScore, setPiscineScore] = useState(null)
    // const [CorrectorComment, setCorrectorComment] = useState([])
    // const [CorrectedComment, setCorrectedComment] = useState([])


    useEffect(() => {
        Axios.get(`/api/subject/${login}`)
            .then(response => {
                if(response.data.success) {
                    setSubject(response.data.data)
                }
            })
        Axios.get(`/api/piscine/${login}`)
            .then(response => {
                if(response.data.success) {
                    setPiscineLevel(response.data.data.level)
                    setPiscineScore(response.data.data.exam)
                }
            })
    }, [])

    console.log(PiscineLevel, PiscineScore)

    return (
        <div style={{ width: '100%', margin: '0' }}>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                
                <h1 style={{ width: '100%', textAlign: 'center' }}>piscine</h1>
                {PiscineLevel, PiscineScore &&
                    <div style={{ display: 'flex', width: '80%' }}>
                        <h3 style={{ width: '50%', textAlign: 'center'}}>{PiscineLevel}</h3>
                        <hr/>
                        <h3 style={{ width: '50%', textAlign: 'center'}}>{PiscineScore}</h3>
                    </div>
                }
                
                <h1>subject</h1>
                {Subject && Subject.map((subject, index) => (
                    <div key={index}>
                        <h3>{subject}</h3>
                    </div>
                ))}

                <div style={{ display: 'flex', justifyContent: 'space-between', flexDirection: 'row'}}>
                    <h1>corrector</h1>
                    <button style={{ width: '100px', height: '50px' }}>더보기</button>
                </div>
                <div style={{ display: 'flex', justifyContent: 'space-between', flexDirection: 'row'}}>
                    <h1>corrected</h1>
                    <button style={{ width: '100px', height: '50px' }}>더보기</button>
                </div>
                {/* <h1>corrector</h1>
                {CorrectorComment && CorrectorComment.map((comment, index) => (
                    <div key={index}>
                        <h3>{login} : {comment.comment}</h3>
                        <h3>상대방 : {comment.feedback}</h3>
                    </div>
                ))
                }

                <h1>corrected</h1>
                {CorrectedComment && CorrectedComment.map((comment, index) => (
                    <div key={index}>
                        <h3>{login} : {comment.comment}</h3>
                        <h3>상대방 : {comment.feedback}</h3>
                    </div>
                ))
                } */}
            
            </div>
        </div>
        
    )
}

export default withRouter(MainPage)
