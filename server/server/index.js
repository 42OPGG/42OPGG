const express = require('express');
const app = express();

const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser")
const cors = require('cors');
const path = require('path');
const request = require('request-promise-native');
const fs = require('fs');
const moment = require('moment')
const { resolve } = require('path');
// const options = {
//     key: fs.readFileSync(''),
//     cert: fs.readFileSync(''),
//     ca: fs.readFileSync('')
// }

const port = 5000
let error = null;

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());

UID = "53969a5e6173673390238aee73ac6808dada239017b0f2b4932524b7e87b6826"
SECRET = "fb1d34c1673a83c8c53a33744b8e16552a512de5510e93b697d162fbdf246b4f"

let access_token;

oauth_data = {
    'grant_type' : 'client_credentials',
    'client_id' : UID,
    'client_secret' : SECRET,
}
oauth_url = "https://api.intra.42.fr/oauth/token"
api_url = "https://api.intra.42.fr/v2"



//과제이력
//피씬 레벨, 파이널 점수
//코멘트들

async function getReq(url) {
    return new Promise((resolve, reject) => {
        request.post({
            url: oauth_url,
            form: oauth_data
        }, (err, res, body) => {
            const access_token = JSON.parse(body).access_token
            const response = request.get({
                url: url,
                form: {
                    'access_token': access_token
                }
            })
            resolve(response)
        })
    })
}

async function subject(response){
    return new Promise((resolve) => {
        let result = []
        JSON.parse(response).forEach((project) => {
            if(project.status === 'finished' && project.project.name.indexOf('Piscine') === -1) {
                result.push(project.project.name)
            }
        })
        resolve(result)
    })
}

async function finalExam(response) {
    return new Promise((resolve) => {
        JSON.parse(response)['projects_users'].forEach(project => {
            if(project.project.id === 1304) {
                resolve(project.final_mark)
            }
        })
    })
}

async function getComment(response, num) {
    return new Promise((resolve) => {
        let result = []
        let count = 0
        JSON.parse(response).some(project => {
            result.push({comment: project.comment, feedback: project.feedback})
            count++
            console.log(count, num)
            if (count == num)
            {
                return true
            } else {
                return false
            }
        })
        resolve(result)
    })
}

app.get('/api/subject/:user_id', async (req, res) => {
    let result;
    try {
        const response = await getReq(`${api_url}/users/${req.params.user_id}/projects_users?range[final_mark]=100,125?filter[cursus]=21`)
        result = await subject(response);
    } catch (err) {
        error = err
        console.log(err)
    }
    if(error) {
        res.status(400).json({ success: 'false', data: error })
    } else {
        res.status(200).json({ success: 'true', data: result })
    }
    
})//1304

app.get('/api/piscine/:user_id', async (req, res) => {
    let level, final;
    try {
        const response = await getReq(`${api_url}/users/${req.params.user_id}`)
        level = JSON.parse(response)['cursus_users'][0].level
        final = await finalExam(response)
    } catch (err) {
        error = err
        console.log(err)

    }
    if(error) {
        res.status(400).json({ success: 'false', data: error })
    } else {
        res.status(200).json({ success: 'true', data: { level: level, exam: final }})
    }
})

app.get('/api/corrector/:user_id/:count', async (req, res) => {
    let comment;
    try {
    const response = await getReq(`${api_url}/users/${req.params.user_id}/scale_teams/as_corrector?range[updated_at]=${moment().subtract(1, 'months').toISOString()}, ${moment().toISOString()}`)
    comment = await getComment(response, req.params.count)
    } catch (err) {
        error = err
        console.log(err)

    }
    if(error) {
        res.status(400).json({ success: 'false', data: error })
    } else {
        res.status(200).json({ success: 'true', data: comment })
    }
})

app.get('/api/corrected/:user_id/:count', async (req, res) => {
    let comment
    try {
        const response = await getReq(`${api_url}/users/${req.params.user_id}/scale_teams/as_corrected?range[updated_at]=${moment().subtract(1, 'months').toISOString()}, ${moment().toISOString()}`)
        comment = await getComment(response, req.params.count)
    } catch (err) {
        error = err
        console.log(err)

    }
    if(error) {
        res.status(400).json({ success: 'false', data: error })
    } else {
        res.status(200).json({ success: 'true', data: comment })
    }
})

app.listen(port, () => console.log(`Server is listening on port ${port}`));

// https.createServer(option, app).listen(port, () => console.log(`Server is listening on port ${port}`));