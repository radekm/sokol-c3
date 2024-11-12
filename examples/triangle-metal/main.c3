//------------------------------------------------------------------------------
//  triangle/main.c3
//
//  Hello Triangle sample.
//  Ported to C3 from `sokol-samples/metal/triangle-metal.c`.
//------------------------------------------------------------------------------

import sokol;

struct State
{
    gfx::Pipeline pip;
    gfx::Bindings bind;
    gfx::PassAction pass_action;
}

State state;

fn void init()
{
    gfx::setup(&&gfx::Desc {
        .environment = glue::environment(),
        .logger = { .func = &log::func },
    });

    // A vertex buffer with 3 vertices.
    float[*] vertices = {
        // Positions         Colors
         0.0,  0.5, 0.5,    1.0, 0.0, 0.0, 1.0,
         0.5, -0.5, 0.5,    0.0, 1.0, 0.0, 1.0,
        -0.5, -0.5, 0.5,    0.0, 0.0, 1.0, 1.0,
    };
    state.bind.vertex_buffers[0] = gfx::make_buffer(&&BufferDesc {
        .data = { .ptr = &vertices, .size = $typeof(vertices).sizeof },
    });

    Shader shd = gfx::make_shader(&&ShaderDesc {
       /*
            The shader main() function cannot be called 'main' in
            the Metal shader languages, thus we define '_main' as the
            default function. This can be override with the
            sg_shader_desc.vs.entry and sg_shader_desc.fs.entry fields.
        */
        .vertex_func.source =
            "#include <metal_stdlib>\n"
            "using namespace metal;\n"
            "struct vs_in {\n"
            "  float4 position [[attribute(0)]];\n"
            "  float4 color [[attribute(1)]];\n"
            "};\n"
            "struct vs_out {\n"
            "  float4 position [[position]];\n"
            "  float4 color;\n"
            "};\n"
            "vertex vs_out _main(vs_in inp [[stage_in]]) {\n"
            "  vs_out outp;\n"
            "  outp.position = inp.position;\n"
            "  outp.color = inp.color;\n"
            "  return outp;\n"
            "}\n",
        .fragment_func.source =
            "#include <metal_stdlib>\n"
            "using namespace metal;\n"
            "fragment float4 _main(float4 color [[stage_in]]) {\n"
            "  return color;\n"
            "};\n"
    });

    // Create a pipeline object.
    state.pip = gfx::make_pipeline(&&PipelineDesc {
        /* Metal has explicit attribute locations, and the vertex layout
           has no gaps, so we don't need to provide stride, offsets
           or attribute names
        */
        .layout = {
            .attrs = {
                [0] = { .format = vertex_format::FLOAT3 },
                [1] = { .format = vertex_format::FLOAT4 }
            },
        },
        .shader = shd
    });

    // A pass action to clear framebuffer to black.
    state.pass_action.colors[0] = {
        .load_action = load_action::CLEAR,
        .clear_value = { .r = 0, .g = 0, .b = 0, .a = 1 },
    };
}

fn void frame()
{
    gfx::begin_pass(&&Pass { .action = state.pass_action, .swapchain = glue::swapchain() });
    gfx::apply_pipeline(state.pip);
    gfx::apply_bindings(&state.bind);
    gfx::draw(0, 3, 1);
    gfx::end_pass();
    gfx::commit();
}

fn void cleanup()
{
    gfx::shutdown();
}

fn void main()
{
    app::run(&&app::Desc {
        .init_cb = &init,
        .frame_cb = &frame,
        .cleanup_cb = &cleanup,
        .width = 640,
        .height = 480,
        .window_title = "triangle",
        .icon = { .sokol_default = true },
        .logger = { .func = &log::func },
    });
}
