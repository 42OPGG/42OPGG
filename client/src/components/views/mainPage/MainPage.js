import React, { useEffect, useState } from 'react'
import { withRouter } from 'react-router-dom'
import Axios from 'axios'


function MainPage(props) {

    const login = props.match.params.login
    const [Subject, setSubject] = useState([])
    const [PiscineLevel, setPiscineLevel] = useState(null)
    const [PiscineScore, setPiscineScore] = useState(null)

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
    }, [login])

    return (
        <div style={{ width: '100%', margin: '0' }}>
            <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
                
                <div style={{ marginTop: '2rem', width: '100%', display: 'flex', alignItems: 'center', flexDirection: 'column' }}>
                    <h1 style={{ width: '100%', textAlign: 'center' }}>piscine</h1>
                    {PiscineLevel, PiscineScore &&
                        <div style={{ display: 'flex', width: '80%' }}>
                            <h3 style={{ width: '50%', textAlign: 'center'}}>level : {PiscineLevel}</h3>
                            <hr/>
                            <h3 style={{ width: '50%', textAlign: 'center'}}>final Exam : {PiscineScore}</h3>
                        </div>
                    }
                </div>
                
                <div style={{ marginTop: '2rem' }}>
                    <h1>subject</h1>
                    {Subject && Subject.map((subject, index) => (
                        <div key={index}>
                            <h3>{subject}</h3>
                        </div>
                    ))}
                </div>
                
                <div style={{ display: 'flex', justifyContent: 'space-between', flexDirection: 'row', marginTop: '2rem' }}>
                    <a href={`/corrector/${login}`}>평가자로서 남긴 코멘트 보기</a>
                </div>

                <div style={{ display: 'flex', justifyContent: 'space-between', flexDirection: 'row', marginTop: '2rem' }}>
                    <a href={`/corrected/${login}`}>피평가자로서 남긴 코멘트 보기</a>
                </div>
            
            </div>
        </div>
        
    )
}

export default withRouter(MainPage)
