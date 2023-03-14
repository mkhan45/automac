use mlua::prelude::*;
use synthesizer::vsa::Lit;

pub fn synthesize<'lua>(lua: &'lua Lua, spec: LuaTable<'lua>) -> LuaResult<LuaValue> {
    let inps_rs = spec.get::<_, Vec<String>>("inputs")?;
    let outs_rs = spec.get::<_, Vec<String>>("outputs")?;

    let examples: Vec<_> = inps_rs.into_iter().zip(outs_rs.into_iter()).map(|(inp, out)| {
        (Lit::StringConst(inp.to_string()), Lit::StringConst(out.to_string()))
    }).collect();

    let (tx, rx) = std::sync::mpsc::channel();
    std::thread::spawn(move || {
        let synthesized = synthesizer::enumerative::duet(&examples);
        tx.send(synthesized).unwrap();
    });

    match rx.recv_timeout(std::time::Duration::from_secs(4)) {
        Ok(Some(synth)) => {
            let eval = lua.create_function(move |lua, inp: String| {
                match synth.eval(&Lit::StringConst(inp)) {
                    Lit::StringConst(s) => Ok(LuaValue::String(lua.create_string(&s)?)),
                    Lit::BoolConst(b) => Ok(LuaValue::Boolean(b)),
                    Lit::LocConst(n) => Ok(LuaValue::Integer(n as i64)),
                    _ => panic!(),
                }
            })?;
            Ok(LuaValue::Function(eval))
        },
        _ => {
            Ok(LuaNil)
        }
    }
}

#[mlua::lua_module]
fn automac_lib(lua: &Lua) -> LuaResult<LuaTable> {
    let table = lua.create_table()?;
    table.set("synthesize", lua.create_function(synthesize)?)?;
    Ok(table)
}
