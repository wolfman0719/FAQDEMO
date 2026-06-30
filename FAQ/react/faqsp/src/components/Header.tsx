import React from 'react';

export const Header = () => {
    
  return (
    <div style={{display: "flex", alignItems: "center", gap: "20px"}}>
      <a href="https://www.intersystems.com/jp" style={{lineHeight: 0}}><img src="https://www.intersystems.com/assets/intersystems-logo.png" alt="InterSystems Corporation" style={{width: 200, height: 50, border: "none", outline: "none", display: "block"}}/></a>
      <p style={{fontSize: "2.5rem", margin: 0, color: "var(--faq-primary-color)"}}> FAQ検索(よくあるご質問)　</p>
    </div>
  );	
}
export default Header;
