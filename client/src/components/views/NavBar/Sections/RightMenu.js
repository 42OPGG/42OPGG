import React, { useState, useEffect } from 'react'
import { Menu } from 'antd'
import { withRouter } from 'react-router-dom'
import Axios from 'axios'

const { SubMenu } = Menu;

function RightMenu(props) {

    const [Value, setValue] = useState('')

    const onClickHandler = (e) => {
        e.preventDefault();
        props.history.push(`/main/${Value}`)
    }

    const onChangeHandler = (e) => {
        setValue(e.currentTarget.value)
    }

        return (
            <Menu mode={props.mode}>
                <div style={{ display: 'flex' }}>
                    <textarea style={{ width: '250px', height: '40px', marginRight: '2rem' }} onChange={onChangeHandler} value={Value} />
                    <Menu.Item key="GG">
                        <a onClick={onClickHandler}>GG</a>
                    </Menu.Item>
                </div>
            </Menu>
        )
    
}

export default withRouter(RightMenu)
