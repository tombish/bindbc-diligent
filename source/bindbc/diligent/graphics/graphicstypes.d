/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Graphics/GraphicsEngine/interface/GraphicsTypes.h
 *  The original licence follows this statement
 */

/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */
 
module bindbc.diligent.graphics.graphicstypes;

import bindbc.diligent.primitives.debugoutput;
public import bindbc.diligent.platforms.nativewindow;
public import bindbc.diligent.graphics.apiinfo;
public import bindbc.diligent.graphics.constants;

/// This enumeration describes value type. It is used by
/// - BufferDesc structure to describe value type of a formatted buffer
/// - DrawAttribs structure to describe index type for an indexed draw call
enum VALUE_TYPE : ubyte 
{
    VT_UNDEFINED = 0, ///< Undefined type
    VT_INT8,          ///< Signed 8-bit integer
    VT_INT16,         ///< Signed 16-bit integer
    VT_INT32,         ///< Signed 32-bit integer
    VT_UINT8,         ///< Unsigned 8-bit integer
    VT_UINT16,        ///< Unsigned 16-bit integer
    VT_UINT32,        ///< Unsigned 32-bit integer
    VT_FLOAT16,       ///< Half-precision 16-bit floating point
    VT_FLOAT32,       ///< Full-precision 32-bit floating point
    VT_NUM_TYPES      ///< Helper value storing total number of types in the enumeration
}
/// Describes the shader type
enum SHADER_TYPE : uint
{
    SHADER_TYPE_UNKNOWN          = 0x0000, ///< Unknown shader type
    SHADER_TYPE_VERTEX           = 0x0001, ///< Vertex shader
    SHADER_TYPE_PIXEL            = 0x0002, ///< Pixel (fragment) shader
    SHADER_TYPE_GEOMETRY         = 0x0004, ///< Geometry shader
    SHADER_TYPE_HULL             = 0x0008, ///< Hull (tessellation control) shader
    SHADER_TYPE_DOMAIN           = 0x0010, ///< Domain (tessellation evaluation) shader
    SHADER_TYPE_COMPUTE          = 0x0020, ///< Compute shader
    SHADER_TYPE_AMPLIFICATION    = 0x0040, ///< Amplification (task) shader
    SHADER_TYPE_MESH             = 0x0080, ///< Mesh shader
    SHADER_TYPE_RAY_GEN          = 0x0100, ///< Ray generation shader
    SHADER_TYPE_RAY_MISS         = 0x0200, ///< Ray miss shader
    SHADER_TYPE_RAY_CLOSEST_HIT  = 0x0400, ///< Ray closest hit shader
    SHADER_TYPE_RAY_ANY_HIT      = 0x0800, ///< Ray any hit shader
    SHADER_TYPE_RAY_INTERSECTION = 0x1000, ///< Ray intersection shader
    SHADER_TYPE_CALLABLE         = 0x2000, ///< Callable shader
    SHADER_TYPE_TILE             = 0x4000, ///< Tile shader (Only for Metal backend)
    SHADER_TYPE_LAST             = SHADER_TYPE_TILE,

    /// All graphics pipeline shader stages
    SHADER_TYPE_ALL_GRAPHICS    = SHADER_TYPE_VERTEX   |
                                  SHADER_TYPE_PIXEL    |
                                  SHADER_TYPE_GEOMETRY | 
                                  SHADER_TYPE_HULL     | 
                                  SHADER_TYPE_DOMAIN,

    /// All mesh shading pipeline stages
    SHADER_TYPE_ALL_MESH        = SHADER_TYPE_AMPLIFICATION |
                                  SHADER_TYPE_MESH |
                                  SHADER_TYPE_PIXEL,

    /// All ray-tracing pipeline shader stages
    SHADER_TYPE_ALL_RAY_TRACING    = SHADER_TYPE_RAY_GEN          |
                                     SHADER_TYPE_RAY_MISS         |
                                     SHADER_TYPE_RAY_CLOSEST_HIT  |
                                     SHADER_TYPE_RAY_ANY_HIT      |
                                     SHADER_TYPE_RAY_INTERSECTION |
                                     SHADER_TYPE_CALLABLE
}

/// Resource binding flags

/// [D3D11_BIND_FLAG]: https://docs.microsoft.com/en-us/windows/win32/api/d3d11/ne-d3d11-d3d11_bind_flag
///
/// This enumeration describes which parts of the pipeline a resource can be bound to.
/// It generally mirrors [D3D11_BIND_FLAG][] enumeration. It is used by
/// - BufferDesc to describe bind flags for a buffer
/// - TextureDesc to describe bind flags for a texture
enum BIND_FLAGS : uint
{
    BIND_NONE                = 0x0,   ///< Undefined binding
    BIND_VERTEX_BUFFER       = 0x1,   ///< A buffer can be bound as a vertex buffer
    BIND_INDEX_BUFFER        = 0x2,   ///< A buffer can be bound as an index buffer
    BIND_UNIFORM_BUFFER      = 0x4,   ///< A buffer can be bound as a uniform buffer
                                       ///  \warning This flag may not be combined with any other bind flag
    BIND_SHADER_RESOURCE     = 0x8,   ///< A buffer or a texture can be bound as a shader resource
                                       ///  \warning This flag cannot be used with MAP_WRITE_NO_OVERWRITE flag 
    BIND_STREAM_OUTPUT       = 0x10,  ///< A buffer can be bound as a target for stream output stage
    BIND_RENDER_TARGET       = 0x20,  ///< A texture can be bound as a render target
    BIND_DEPTH_STENCIL       = 0x40,  ///< A texture can be bound as a depth-stencil target
    BIND_UNORDERED_ACCESS    = 0x80,  ///< A buffer or a texture can be bound as an unordered access view
    BIND_INDIRECT_DRAW_ARGS  = 0x100, ///< A buffer can be bound as the source buffer for indirect draw commands
    BIND_INPUT_ATTACHMENT    = 0x200, ///< A texture can be used as render pass input attachment
    BIND_RAY_TRACING         = 0x400, ///< A buffer can be used as a scratch buffer or as the source of primitive data 
                                      ///  for acceleration structure building
    BIND_FLAGS_LAST          = 0x400
}

/// Resource usage

/// [D3D11_USAGE]: https://docs.microsoft.com/en-us/windows/win32/api/d3d11/ne-d3d11-d3d11_usage
/// This enumeration describes expected resource usage. It generally mirrors [D3D11_USAGE] enumeration.
/// The enumeration is used by
/// - BufferDesc to describe usage for a buffer
/// - TextureDesc to describe usage for a texture
enum USAGE : ubyte
{
    /// A resource that can only be read by the GPU. It cannot be written by the GPU, 
    /// and cannot be accessed at all by the CPU. This type of resource must be initialized 
    /// when it is created, since it cannot be changed after creation. \n
    /// D3D11 Counterpart: D3D11_USAGE_IMMUTABLE. OpenGL counterpart: GL_STATIC_DRAW
    /// \remarks Static buffers do not allow CPU access and must use CPU_ACCESS_NONE flag.
    USAGE_IMMUTABLE = 0, 

    /// A resource that requires read and write access by the GPU and can also be occasionally
    /// written by the CPU.  \n
    /// D3D11 Counterpart: D3D11_USAGE_DEFAULT. OpenGL counterpart: GL_DYNAMIC_DRAW.
    /// \remarks Default buffers do not allow CPU access and must use CPU_ACCESS_NONE flag.
    USAGE_DEFAULT,

    /// A resource that can be read by the GPU and written at least once per frame by the CPU.  \n
    /// D3D11 Counterpart: D3D11_USAGE_DYNAMIC. OpenGL counterpart: GL_STREAM_DRAW
    /// \remarks Dynamic buffers must use CPU_ACCESS_WRITE flag.
    USAGE_DYNAMIC,

    /// A resource that facilitates transferring data between GPU and CPU. \n
    /// D3D11 Counterpart: D3D11_USAGE_STAGING. OpenGL counterpart: GL_STATIC_READ or
    /// GL_STATIC_COPY depending on the CPU access flags.
    /// \remarks Staging buffers must use exactly one of CPU_ACCESS_WRITE or CPU_ACCESS_READ flags.
    USAGE_STAGING,

    /// A resource residing in a unified memory (e.g. memory shared between CPU and GPU),
    /// that can be read and written by GPU and can also be directly accessed by CPU.
    ///
    /// \remarks An application should check if unified memory is available on the device by querying
    ///          the adapter info (see Diligent::IRenderDevice::GetAdapterInfo().Memory and Diligent::AdapterMemoryInfo).
    ///          If there is no unified memory, an application should choose another usage type (typically, USAGE_DEFAULT).
    /// 
    ///          Unified resources must use at least one of CPU_ACCESS_WRITE or CPU_ACCESS_READ flags.
    ///          An application should check supported unified memory CPU access types by querying the device caps.
    ///          (see Diligent::AdapterMemoryInfo::UnifiedMemoryCPUAccess).
    USAGE_UNIFIED,

    /// Helper value indicating the total number of elements in the enum
    USAGE_NUM_USAGES
}

/// Allowed CPU access mode flags when mapping a resource
    
/// The enumeration is used by
/// - BufferDesc to describe CPU access mode for a buffer
/// - TextureDesc to describe CPU access mode for a texture
/// \note Only USAGE_DYNAMIC resources can be mapped
enum CPU_ACCESS_FLAGS : ubyte
{
    CPU_ACCESS_NONE  = 0x00, ///< No CPU access
    CPU_ACCESS_READ  = 0x01, ///< A resource can be mapped for reading
    CPU_ACCESS_WRITE = 0x02  ///< A resource can be mapped for writing
}

/// Resource mapping type

/// [D3D11_MAP]: https://docs.microsoft.com/en-us/windows/win32/api/d3d11/ne-d3d11-d3d11_map
/// Describes how a mapped resource will be accessed. This enumeration generally
/// mirrors [D3D11_MAP][] enumeration. It is used by
/// - IBuffer::Map to describe buffer mapping type
/// - ITexture::Map to describe texture mapping type
enum MAP_TYPE : ubyte
{
    /// The resource is mapped for reading. \n
    /// D3D11 counterpart: D3D11_MAP_READ. OpenGL counterpart: GL_MAP_READ_BIT
    MAP_READ = 0x01,       

    /// The resource is mapped for writing. \n
    /// D3D11 counterpart: D3D11_MAP_WRITE. OpenGL counterpart: GL_MAP_WRITE_BIT
    MAP_WRITE = 0x02,          

    /// The resource is mapped for reading and writing. \n
    /// D3D11 counterpart: D3D11_MAP_READ_WRITE. OpenGL counterpart: GL_MAP_WRITE_BIT | GL_MAP_READ_BIT
    MAP_READ_WRITE = 0x03
}

/// Special map flags

/// Describes special arguments for a map operation.
/// This enumeration is used by
/// - IBuffer::Map to describe buffer mapping flags
/// - ITexture::Map to describe texture mapping flags
enum MAP_FLAGS : ubyte
{
    MAP_FLAG_NONE         = 0x000,

    /// Specifies that map operation should not wait until previous command that
    /// using the same resource completes. Map returns null pointer if the resource
    /// is still in use.\n
    /// D3D11 counterpart:  D3D11_MAP_FLAG_DO_NOT_WAIT
    /// \note: OpenGL does not have corresponding flag, so a buffer will always be mapped
    MAP_FLAG_DO_NOT_WAIT  = 0x001,

    /// Previous contents of the resource will be undefined. This flag is only compatible with MAP_WRITE\n
    /// D3D11 counterpart: D3D11_MAP_WRITE_DISCARD. OpenGL counterpart: GL_MAP_INVALIDATE_BUFFER_BIT
    /// \note OpenGL implementation may orphan a buffer instead 
    MAP_FLAG_DISCARD      = 0x002,

    /// The system will not synchronize pending operations before mapping the buffer. It is responsibility
    /// of the application to make sure that the buffer contents is not overwritten while it is in use by 
    /// the GPU.\n
    /// D3D11 counterpart:  D3D11_MAP_WRITE_NO_OVERWRITE. OpenGL counterpart: GL_MAP_UNSYNCHRONIZED_BIT
    MAP_FLAG_NO_OVERWRITE = 0x004
}

/// Describes resource dimension

/// This enumeration is used by
/// - TextureDesc to describe texture type
/// - TextureViewDesc to describe texture view type
enum RESOURCE_DIMENSION : ubyte
{
    RESOURCE_DIM_UNDEFINED = 0,  ///< Texture type undefined
    RESOURCE_DIM_BUFFER,         ///< Buffer
    RESOURCE_DIM_TEX_1D,         ///< One-dimensional texture
    RESOURCE_DIM_TEX_1D_ARRAY,   ///< One-dimensional texture array
    RESOURCE_DIM_TEX_2D,         ///< Two-dimensional texture
    RESOURCE_DIM_TEX_2D_ARRAY,   ///< Two-dimensional texture array
    RESOURCE_DIM_TEX_3D,         ///< Three-dimensional texture
    RESOURCE_DIM_TEX_CUBE,       ///< Cube-map texture
    RESOURCE_DIM_TEX_CUBE_ARRAY, ///< Cube-map array texture
    RESOURCE_DIM_NUM_DIMENSIONS  ///< Helper value that stores the total number of texture types in the enumeration
}

/// Texture view type

/// This enumeration describes allowed view types for a texture view. It is used by TextureViewDesc
/// structure.
enum TEXTURE_VIEW_TYPE : ubyte
{
    /// Undefined view type
    TEXTURE_VIEW_UNDEFINED = 0,

    /// A texture view will define a shader resource view that will be used 
    /// as the source for the shader read operations
    TEXTURE_VIEW_SHADER_RESOURCE,

    /// A texture view will define a render target view that will be used
    /// as the target for rendering operations
    TEXTURE_VIEW_RENDER_TARGET,

    /// A texture view will define a depth stencil view that will be used
    /// as the target for rendering operations
    TEXTURE_VIEW_DEPTH_STENCIL,

    /// A texture view will define an unordered access view that will be used
    /// for unordered read/write operations from the shaders
    TEXTURE_VIEW_UNORDERED_ACCESS,

    /// Helper value that stores that total number of texture views
    TEXTURE_VIEW_NUM_VIEWS
}

/// Buffer view type

/// This enumeration describes allowed view types for a buffer view. It is used by BufferViewDesc
/// structure.
enum BUFFER_VIEW_TYPE : ubyte
{
    /// Undefined view type
    BUFFER_VIEW_UNDEFINED = 0,

    /// A buffer view will define a shader resource view that will be used 
    /// as the source for the shader read operations
    BUFFER_VIEW_SHADER_RESOURCE,

    /// A buffer view will define an unordered access view that will be used
    /// for unordered read/write operations from the shaders
    BUFFER_VIEW_UNORDERED_ACCESS,

    /// Helper value that stores that total number of buffer views
    BUFFER_VIEW_NUM_VIEWS
}

/// Texture formats

/// This enumeration describes available texture formats and generally mirrors DXGI_FORMAT enumeration.
/// The table below provides detailed information on each format. Most of the formats are widely supported 
/// by all modern APIs (DX10+, OpenGL3.3+ and OpenGLES3.0+). Specific requirements are additionally indicated.
/// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/api/dxgiformat/ne-dxgiformat-dxgi_format">DXGI_FORMAT enumeration on MSDN</a>, 
///     <a href = "https://www.opengl.org/wiki/Image_Format">OpenGL Texture Formats</a>
///
enum TEXTURE_FORMAT : ushort
{
    /// Unknown format
    TEX_FORMAT_UNKNOWN = 0,

    /// Four-component 128-bit typeless format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32A32_TYPELESS. OpenGL does not have direct counterpart, GL_RGBA32F is used.
    TEX_FORMAT_RGBA32_TYPELESS,

    /// Four-component 128-bit floating-point format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32A32_FLOAT. OpenGL counterpart: GL_RGBA32F.
    TEX_FORMAT_RGBA32_FLOAT,  

    /// Four-component 128-bit unsigned-integer format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32A32_UINT. OpenGL counterpart: GL_RGBA32UI.
    TEX_FORMAT_RGBA32_UINT,

    /// Four-component 128-bit signed-integer format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32A32_SINT. OpenGL counterpart: GL_RGBA32I.
    TEX_FORMAT_RGBA32_SINT,  

    /// Three-component 96-bit typeless format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32_TYPELESS. OpenGL does not have direct counterpart, GL_RGB32F is used.
    /// \warning This format has weak hardware support and is not recommended 
    TEX_FORMAT_RGB32_TYPELESS,  

    /// Three-component 96-bit floating-point format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32_FLOAT. OpenGL counterpart: GL_RGB32F.
    /// \warning This format has weak hardware support and is not recommended 
    TEX_FORMAT_RGB32_FLOAT,  

    /// Three-component 96-bit unsigned-integer format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32_UINT. OpenGL counterpart: GL_RGB32UI.
    /// \warning This format has weak hardware support and is not recommended 
    TEX_FORMAT_RGB32_UINT,  

    /// Three-component 96-bit signed-integer format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32B32_SINT. OpenGL counterpart: GL_RGB32I.
    /// \warning This format has weak hardware support and is not recommended 
    TEX_FORMAT_RGB32_SINT,  

    /// Four-component 64-bit typeless format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16B16A16_TYPELESS. OpenGL does not have direct counterpart, GL_RGBA16F is used.
    TEX_FORMAT_RGBA16_TYPELESS,  

    /// Four-component 64-bit half-precision floating-point format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16B16A16_FLOAT. OpenGL counterpart: GL_RGBA16F.
    TEX_FORMAT_RGBA16_FLOAT, 

    /// Four-component 64-bit unsigned-normalized-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16B16A16_UNORM. OpenGL counterpart: GL_RGBA16. \n
    /// [GL_EXT_texture_norm16]: https://www.khronos.org/registry/gles/extensions/EXT/EXT_texture_norm16.txt
    /// OpenGLES: [GL_EXT_texture_norm16][] extension is required
    TEX_FORMAT_RGBA16_UNORM, 

    /// Four-component 64-bit unsigned-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16B16A16_UINT. OpenGL counterpart: GL_RGBA16UI.
    TEX_FORMAT_RGBA16_UINT, 

    /// [GL_EXT_texture_norm16]: https://www.khronos.org/registry/gles/extensions/EXT/EXT_texture_norm16.txt
    /// Four-component 64-bit signed-normalized-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16B16A16_SNORM. OpenGL counterpart: GL_RGBA16_SNORM. \n
    /// [GL_EXT_texture_norm16]: https://www.khronos.org/registry/gles/extensions/EXT/EXT_texture_norm16.txt
    /// OpenGLES: [GL_EXT_texture_norm16][] extension is required
    TEX_FORMAT_RGBA16_SNORM, 

    /// Four-component 64-bit signed-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16B16A16_SINT. OpenGL counterpart: GL_RGBA16I.
    TEX_FORMAT_RGBA16_SINT, 

    /// Two-component 64-bit typeless format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32_TYPELESS. OpenGL does not have direct counterpart, GL_RG32F is used.
    TEX_FORMAT_RG32_TYPELESS, 

    /// Two-component 64-bit floating-point format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32_FLOAT. OpenGL counterpart: GL_RG32F.
    TEX_FORMAT_RG32_FLOAT, 

    /// Two-component 64-bit unsigned-integer format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32_UINT. OpenGL counterpart: GL_RG32UI.
    TEX_FORMAT_RG32_UINT, 

    /// Two-component 64-bit signed-integer format with 32-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R32G32_SINT. OpenGL counterpart: GL_RG32I.
    TEX_FORMAT_RG32_SINT, 

    /// Two-component 64-bit typeless format with 32-bits for R channel and 8 bits for G channel. \n
    /// D3D counterpart: DXGI_FORMAT_R32G8X24_TYPELESS. OpenGL does not have direct counterpart, GL_DEPTH32F_STENCIL8 is used.
    TEX_FORMAT_R32G8X24_TYPELESS, 

    /// Two-component 64-bit format with 32-bit floating-point depth channel and 8-bit stencil channel. \n
    /// D3D counterpart: DXGI_FORMAT_D32_FLOAT_S8X24_UINT. OpenGL counterpart: GL_DEPTH32F_STENCIL8.
    TEX_FORMAT_D32_FLOAT_S8X24_UINT, 

    /// Two-component 64-bit format with 32-bit floating-point R channel and 8+24-bits of typeless data. \n
    /// D3D counterpart: DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS. OpenGL does not have direct counterpart, GL_DEPTH32F_STENCIL8 is used.
    TEX_FORMAT_R32_FLOAT_X8X24_TYPELESS, 

    /// Two-component 64-bit format with 32-bit typeless data and 8-bit G channel. \n
    /// D3D counterpart: DXGI_FORMAT_X32_TYPELESS_G8X24_UINT
    /// \warning This format is currently not implemented in OpenGL version
    TEX_FORMAT_X32_TYPELESS_G8X24_UINT, 

    /// Four-component 32-bit typeless format with 10 bits for RGB and 2 bits for alpha channel. \n
    /// D3D counterpart: DXGI_FORMAT_R10G10B10A2_TYPELESS. OpenGL does not have direct counterpart, GL_RGB10_A2 is used.
    TEX_FORMAT_RGB10A2_TYPELESS, 

    /// Four-component 32-bit unsigned-normalized-integer format with 10 bits for each color and 2 bits for alpha channel. \n
    /// D3D counterpart: DXGI_FORMAT_R10G10B10A2_UNORM. OpenGL counterpart: GL_RGB10_A2.
    TEX_FORMAT_RGB10A2_UNORM, 

    /// Four-component 32-bit unsigned-integer format with 10 bits for each color and 2 bits for alpha channel. \n
    /// D3D counterpart: DXGI_FORMAT_R10G10B10A2_UINT. OpenGL counterpart: GL_RGB10_A2UI.
    TEX_FORMAT_RGB10A2_UINT, 

    /// Three-component 32-bit format encoding three partial precision channels using 11 bits for red and green and 10 bits for blue channel. \n
    /// D3D counterpart: DXGI_FORMAT_R11G11B10_FLOAT. OpenGL counterpart: GL_R11F_G11F_B10F.
    TEX_FORMAT_R11G11B10_FLOAT, 

    /// Four-component 32-bit typeless format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8B8A8_TYPELESS. OpenGL does not have direct counterpart, GL_RGBA8 is used.
    TEX_FORMAT_RGBA8_TYPELESS, 

    /// Four-component 32-bit unsigned-normalized-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8B8A8_UNORM. OpenGL counterpart: GL_RGBA8.
    TEX_FORMAT_RGBA8_UNORM,

    /// Four-component 32-bit unsigned-normalized-integer sRGB format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8B8A8_UNORM_SRGB. OpenGL counterpart: GL_SRGB8_ALPHA8.
    TEX_FORMAT_RGBA8_UNORM_SRGB, 

    /// Four-component 32-bit unsigned-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8B8A8_UINT. OpenGL counterpart: GL_RGBA8UI.
    TEX_FORMAT_RGBA8_UINT, 

    /// Four-component 32-bit signed-normalized-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8B8A8_SNORM. OpenGL counterpart: GL_RGBA8_SNORM.
    TEX_FORMAT_RGBA8_SNORM, 

    /// Four-component 32-bit signed-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8B8A8_SINT. OpenGL counterpart: GL_RGBA8I.
    TEX_FORMAT_RGBA8_SINT, 

    /// Two-component 32-bit typeless format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16_TYPELESS. OpenGL does not have direct counterpart, GL_RG16F is used.
    TEX_FORMAT_RG16_TYPELESS, 

    /// Two-component 32-bit half-precision floating-point format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16_FLOAT. OpenGL counterpart: GL_RG16F.
    TEX_FORMAT_RG16_FLOAT, 

    /// Two-component 32-bit unsigned-normalized-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16_UNORM. OpenGL counterpart: GL_RG16. \n
    /// [GL_EXT_texture_norm16]: https://www.khronos.org/registry/gles/extensions/EXT/EXT_texture_norm16.txt
    /// OpenGLES: [GL_EXT_texture_norm16][] extension is required
    TEX_FORMAT_RG16_UNORM, 

    /// Two-component 32-bit unsigned-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16_UINT. OpenGL counterpart: GL_RG16UI.
    TEX_FORMAT_RG16_UINT, 

    /// Two-component 32-bit signed-normalized-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16_SNORM. OpenGL counterpart: GL_RG16_SNORM. \n
    /// [GL_EXT_texture_norm16]: https://www.khronos.org/registry/gles/extensions/EXT/EXT_texture_norm16.txt
    /// OpenGLES: [GL_EXT_texture_norm16][] extension is required
    TEX_FORMAT_RG16_SNORM, 

    /// Two-component 32-bit signed-integer format with 16-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R16G16_SINT. OpenGL counterpart: GL_RG16I.
    TEX_FORMAT_RG16_SINT, 

    /// Single-component 32-bit typeless format. \n
    /// D3D counterpart: DXGI_FORMAT_R32_TYPELESS. OpenGL does not have direct counterpart, GL_R32F is used.
    TEX_FORMAT_R32_TYPELESS, 

    /// Single-component 32-bit floating-point depth format. \n
    /// D3D counterpart: DXGI_FORMAT_D32_FLOAT. OpenGL counterpart: GL_DEPTH_COMPONENT32F.
    TEX_FORMAT_D32_FLOAT, 

    /// Single-component 32-bit floating-point format. \n
    /// D3D counterpart: DXGI_FORMAT_R32_FLOAT. OpenGL counterpart: GL_R32F.
    TEX_FORMAT_R32_FLOAT, 

    /// Single-component 32-bit unsigned-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R32_UINT. OpenGL counterpart: GL_R32UI.
    TEX_FORMAT_R32_UINT, 

    /// Single-component 32-bit signed-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R32_SINT. OpenGL counterpart: GL_R32I.
    TEX_FORMAT_R32_SINT, 

    /// Two-component 32-bit typeless format with 24 bits for R and 8 bits for G channel. \n
    /// D3D counterpart: DXGI_FORMAT_R24G8_TYPELESS. OpenGL does not have direct counterpart, GL_DEPTH24_STENCIL8 is used.
    TEX_FORMAT_R24G8_TYPELESS, 

    /// Two-component 32-bit format with 24 bits for unsigned-normalized-integer depth and 8 bits for stencil. \n
    /// D3D counterpart: DXGI_FORMAT_D24_UNORM_S8_UINT. OpenGL counterpart: GL_DEPTH24_STENCIL8.
    TEX_FORMAT_D24_UNORM_S8_UINT, 

    /// Two-component 32-bit format with 24 bits for unsigned-normalized-integer data and 8 bits of unreferenced data. \n
    /// D3D counterpart: DXGI_FORMAT_R24_UNORM_X8_TYPELESS. OpenGL does not have direct counterpart, GL_DEPTH24_STENCIL8 is used.
    TEX_FORMAT_R24_UNORM_X8_TYPELESS, 

    /// Two-component 32-bit format with 24 bits of unreferenced data and 8 bits of unsigned-integer data. \n
    /// D3D counterpart: DXGI_FORMAT_X24_TYPELESS_G8_UINT
    /// \warning This format is currently not implemented in OpenGL version
    TEX_FORMAT_X24_TYPELESS_G8_UINT, 

    /// Two-component 16-bit typeless format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8_TYPELESS. OpenGL does not have direct counterpart, GL_RG8 is used.
    TEX_FORMAT_RG8_TYPELESS, 

    /// Two-component 16-bit unsigned-normalized-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8_UNORM. OpenGL counterpart: GL_RG8.
    TEX_FORMAT_RG8_UNORM, 

    /// Two-component 16-bit unsigned-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8_UINT. OpenGL counterpart: GL_RG8UI.
    TEX_FORMAT_RG8_UINT, 

    /// Two-component 16-bit signed-normalized-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8_SNORM. OpenGL counterpart: GL_RG8_SNORM.
    TEX_FORMAT_RG8_SNORM, 

    /// Two-component 16-bit signed-integer format with 8-bit channels. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8_SINT. OpenGL counterpart: GL_RG8I.
    TEX_FORMAT_RG8_SINT, 

    /// Single-component 16-bit typeless format. \n
    /// D3D counterpart: DXGI_FORMAT_R16_TYPELESS. OpenGL does not have direct counterpart, GL_R16F is used.
    TEX_FORMAT_R16_TYPELESS, 

    /// Single-component 16-bit half-precisoin floating-point format. \n
    /// D3D counterpart: DXGI_FORMAT_R16_FLOAT. OpenGL counterpart: GL_R16F.
    TEX_FORMAT_R16_FLOAT, 

    /// Single-component 16-bit unsigned-normalized-integer depth format. \n
    /// D3D counterpart: DXGI_FORMAT_D16_UNORM. OpenGL counterpart: GL_DEPTH_COMPONENT16.
    TEX_FORMAT_D16_UNORM, 

    /// Single-component 16-bit unsigned-normalized-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R16_UNORM. OpenGL counterpart: GL_R16.
    /// [GL_EXT_texture_norm16]: https://www.khronos.org/registry/gles/extensions/EXT/EXT_texture_norm16.txt
    /// OpenGLES: [GL_EXT_texture_norm16][] extension is required
    TEX_FORMAT_R16_UNORM, 

    /// Single-component 16-bit unsigned-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R16_UINT. OpenGL counterpart: GL_R16UI.
    TEX_FORMAT_R16_UINT, 

    /// Single-component 16-bit signed-normalized-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R16_SNORM. OpenGL counterpart: GL_R16_SNORM. \n
    /// [GL_EXT_texture_norm16]: https://www.khronos.org/registry/gles/extensions/EXT/EXT_texture_norm16.txt
    /// OpenGLES: [GL_EXT_texture_norm16][] extension is required
    TEX_FORMAT_R16_SNORM, 

    /// Single-component 16-bit signed-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R16_SINT. OpenGL counterpart: GL_R16I.
    TEX_FORMAT_R16_SINT, 

    /// Single-component 8-bit typeless format. \n
    /// D3D counterpart: DXGI_FORMAT_R8_TYPELESS. OpenGL does not have direct counterpart, GL_R8 is used.
    TEX_FORMAT_R8_TYPELESS, 

    /// Single-component 8-bit unsigned-normalized-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R8_UNORM. OpenGL counterpart: GL_R8.
    TEX_FORMAT_R8_UNORM, 

    /// Single-component 8-bit unsigned-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R8_UINT. OpenGL counterpart: GL_R8UI.
    TEX_FORMAT_R8_UINT, 

    /// Single-component 8-bit signed-normalized-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R8_SNORM. OpenGL counterpart: GL_R8_SNORM.
    TEX_FORMAT_R8_SNORM, 

    /// Single-component 8-bit signed-integer format. \n
    /// D3D counterpart: DXGI_FORMAT_R8_SINT. OpenGL counterpart: GL_R8I.
    TEX_FORMAT_R8_SINT, 

    /// Single-component 8-bit unsigned-normalized-integer format for alpha only. \n
    /// D3D counterpart: DXGI_FORMAT_A8_UNORM
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_A8_UNORM, 

    /// Single-component 1-bit format. \n
    /// D3D counterpart: DXGI_FORMAT_R1_UNORM
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_R1_UNORM, 

    /// Three partial-precision floating pointer numbers sharing single exponent encoded into a 32-bit value. \n
    /// D3D counterpart: DXGI_FORMAT_R9G9B9E5_SHAREDEXP. OpenGL counterpart: GL_RGB9_E5.
    TEX_FORMAT_RGB9E5_SHAREDEXP, 

    /// Four-component unsigned-normalized integer format analogous to UYVY encoding. \n
    /// D3D counterpart: DXGI_FORMAT_R8G8_B8G8_UNORM
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_RG8_B8G8_UNORM, 

    /// Four-component unsigned-normalized integer format analogous to YUY2 encoding. \n
    /// D3D counterpart: DXGI_FORMAT_G8R8_G8B8_UNORM
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_G8R8_G8B8_UNORM, 

    /// Four-component typeless block-compression format with 1:8 compression ratio.\n
    /// D3D counterpart: DXGI_FORMAT_BC1_TYPELESS. OpenGL does not have direct counterpart, GL_COMPRESSED_RGB_S3TC_DXT1_EXT is used. \n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc1">BC1 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT1_Format">DXT1 on OpenGL.org </a>
    TEX_FORMAT_BC1_TYPELESS, 

    /// Four-component unsigned-normalized-integer block-compression format with 5 bits for R, 6 bits for G, 5 bits for B, and 0 or 1 bit for A channel. 
    /// The pixel data is encoded using 8 bytes per 4x4 block (4 bits per pixel) providing 1:8 compression ratio against RGBA8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC1_UNORM. OpenGL counterpart: GL_COMPRESSED_RGB_S3TC_DXT1_EXT.\n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc1">BC1 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT1_Format">DXT1 on OpenGL.org </a>
    TEX_FORMAT_BC1_UNORM,

    /// Four-component unsigned-normalized-integer block-compression sRGB format with 5 bits for R, 6 bits for G, 5 bits for B, and 0 or 1 bit for A channel. \n
    /// The pixel data is encoded using 8 bytes per 4x4 block (4 bits per pixel) providing 1:8 compression ratio against RGBA8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC1_UNORM_SRGB. OpenGL counterpart: GL_COMPRESSED_SRGB_S3TC_DXT1_EXT.\n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc1">BC1 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT1_Format">DXT1 on OpenGL.org </a>
    TEX_FORMAT_BC1_UNORM_SRGB,

    /// Four component typeless block-compression format with 1:4 compression ratio.\n
    /// D3D counterpart: DXGI_FORMAT_BC2_TYPELESS. OpenGL does not have direct counterpart, GL_COMPRESSED_RGBA_S3TC_DXT3_EXT is used. \n 
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc2">BC2 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT3_Format">DXT3 on OpenGL.org </a>
    TEX_FORMAT_BC2_TYPELESS, 

    /// Four-component unsigned-normalized-integer block-compression format with 5 bits for R, 6 bits for G, 5 bits for B, and 4 bits for low-coherent separate A channel.
    /// The pixel data is encoded using 16 bytes per 4x4 block (8 bits per pixel) providing 1:4 compression ratio against RGBA8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC2_UNORM. OpenGL counterpart: GL_COMPRESSED_RGBA_S3TC_DXT3_EXT. \n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc2">BC2 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT3_Format">DXT3 on OpenGL.org </a>
    TEX_FORMAT_BC2_UNORM,

    /// Four-component signed-normalized-integer block-compression sRGB format with 5 bits for R, 6 bits for G, 5 bits for B, and 4 bits for low-coherent separate A channel.
    /// The pixel data is encoded using 16 bytes per 4x4 block (8 bits per pixel) providing 1:4 compression ratio against RGBA8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC2_UNORM_SRGB. OpenGL counterpart: GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT3_EXT. \n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc2">BC2 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT3_Format">DXT3 on OpenGL.org </a>
    TEX_FORMAT_BC2_UNORM_SRGB,

    /// Four-component typeless block-compression format with 1:4 compression ratio.\n
    /// D3D counterpart: DXGI_FORMAT_BC3_TYPELESS. OpenGL does not have direct counterpart, GL_COMPRESSED_RGBA_S3TC_DXT5_EXT is used. \n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc3">BC3 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT5_Format">DXT5 on OpenGL.org </a>
    TEX_FORMAT_BC3_TYPELESS, 

    /// Four-component unsigned-normalized-integer block-compression format with 5 bits for R, 6 bits for G, 5 bits for B, and 8 bits for highly-coherent A channel.
    /// The pixel data is encoded using 16 bytes per 4x4 block (8 bits per pixel) providing 1:4 compression ratio against RGBA8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC3_UNORM. OpenGL counterpart: GL_COMPRESSED_RGBA_S3TC_DXT5_EXT. \n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc3">BC3 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT5_Format">DXT5 on OpenGL.org </a>
    TEX_FORMAT_BC3_UNORM,

    /// Four-component unsigned-normalized-integer block-compression sRGB format with 5 bits for R, 6 bits for G, 5 bits for B, and 8 bits for highly-coherent A channel.
    /// The pixel data is encoded using 16 bytes per 4x4 block (8 bits per pixel) providing 1:4 compression ratio against RGBA8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC3_UNORM_SRGB. OpenGL counterpart: GL_COMPRESSED_SRGB_ALPHA_S3TC_DXT5_EXT. \n
    /// [GL_EXT_texture_compression_s3tc]: https://www.khronos.org/registry/gles/extensions/EXT/texture_compression_s3tc.txt
    /// OpenGL & OpenGLES: [GL_EXT_texture_compression_s3tc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc3">BC3 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/S3_Texture_Compression#DXT5_Format">DXT5 on OpenGL.org </a>
    TEX_FORMAT_BC3_UNORM_SRGB,

    /// One-component typeless block-compression format with 1:2 compression ratio. \n
    /// D3D counterpart: DXGI_FORMAT_BC4_TYPELESS. OpenGL does not have direct counterpart, GL_COMPRESSED_RED_RGTC1 is used. \n
    /// [GL_ARB_texture_compression_rgtc]: https://www.opengl.org/registry/specs/ARB/texture_compression_rgtc.txt
    /// OpenGL & OpenGLES: [GL_ARB_texture_compression_rgtc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc4">BC4 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/Image_Format#Compressed_formats">Compressed formats on OpenGL.org </a>
    TEX_FORMAT_BC4_TYPELESS, 

    /// One-component unsigned-normalized-integer block-compression format with 8 bits for R channel.
    /// The pixel data is encoded using 8 bytes per 4x4 block (4 bits per pixel) providing 1:2 compression ratio against R8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC4_UNORM. OpenGL counterpart: GL_COMPRESSED_RED_RGTC1. \n
    /// [GL_ARB_texture_compression_rgtc]: https://www.opengl.org/registry/specs/ARB/texture_compression_rgtc.txt
    /// OpenGL & OpenGLES: [GL_ARB_texture_compression_rgtc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc4">BC4 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/Image_Format#Compressed_formats">Compressed formats on OpenGL.org </a>
    TEX_FORMAT_BC4_UNORM,

    /// One-component signed-normalized-integer block-compression format with 8 bits for R channel.
    /// The pixel data is encoded using 8 bytes per 4x4 block (4 bits per pixel) providing 1:2 compression ratio against R8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC4_SNORM. OpenGL counterpart: GL_COMPRESSED_SIGNED_RED_RGTC1. \n
    /// [GL_ARB_texture_compression_rgtc]: https://www.opengl.org/registry/specs/ARB/texture_compression_rgtc.txt
    /// OpenGL & OpenGLES: [GL_ARB_texture_compression_rgtc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc4">BC4 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/Image_Format#Compressed_formats">Compressed formats on OpenGL.org </a>
    TEX_FORMAT_BC4_SNORM,

    /// Two-component typeless block-compression format with 1:2 compression ratio. \n
    /// D3D counterpart: DXGI_FORMAT_BC5_TYPELESS. OpenGL does not have direct counterpart, GL_COMPRESSED_RG_RGTC2 is used. \n
    /// [GL_ARB_texture_compression_rgtc]: https://www.opengl.org/registry/specs/ARB/texture_compression_rgtc.txt
    /// OpenGL & OpenGLES: [GL_ARB_texture_compression_rgtc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc5">BC5 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/Image_Format#Compressed_formats">Compressed formats on OpenGL.org </a>
    TEX_FORMAT_BC5_TYPELESS,

    /// Two-component unsigned-normalized-integer block-compression format with 8 bits for R and 8 bits for G channel.
    /// The pixel data is encoded using 16 bytes per 4x4 block (8 bits per pixel) providing 1:2 compression ratio against RG8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC5_UNORM. OpenGL counterpart: GL_COMPRESSED_RG_RGTC2. \n
    /// [GL_ARB_texture_compression_rgtc]: https://www.opengl.org/registry/specs/ARB/texture_compression_rgtc.txt
    /// OpenGL & OpenGLES: [GL_ARB_texture_compression_rgtc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc5">BC5 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/Image_Format#Compressed_formats">Compressed formats on OpenGL.org </a>
    TEX_FORMAT_BC5_UNORM,

    /// Two-component signed-normalized-integer block-compression format with 8 bits for R and 8 bits for G channel.
    /// The pixel data is encoded using 16 bytes per 4x4 block (8 bits per pixel) providing 1:2 compression ratio against RG8 format. \n
    /// D3D counterpart: DXGI_FORMAT_BC5_SNORM. OpenGL counterpart: GL_COMPRESSED_SIGNED_RG_RGTC2. \n
    /// [GL_ARB_texture_compression_rgtc]: https://www.opengl.org/registry/specs/ARB/texture_compression_rgtc.txt
    /// OpenGL & OpenGLES: [GL_ARB_texture_compression_rgtc][] extension is required
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d10/d3d10-graphics-programming-guide-resources-block-compression#bc5">BC5 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/Image_Format#Compressed_formats">Compressed formats on OpenGL.org </a>
    TEX_FORMAT_BC5_SNORM,

    /// Three-component 16-bit unsigned-normalized-integer format with 5 bits for blue, 6 bits for green, and 5 bits for red channel. \n
    /// D3D counterpart: DXGI_FORMAT_B5G6R5_UNORM
    /// \warning This format is not available until D3D11.1 and Windows 8. It is also not available in OpenGL
    TEX_FORMAT_B5G6R5_UNORM,

    /// Four-component 16-bit unsigned-normalized-integer format with 5 bits for each color channel and 1-bit alpha. \n
    /// D3D counterpart: DXGI_FORMAT_B5G5R5A1_UNORM
    /// \warning This format is not available until D3D11.1 and Windows 8. It is also not available in OpenGL
    TEX_FORMAT_B5G5R5A1_UNORM, 

    /// Four-component 32-bit unsigned-normalized-integer format with 8 bits for each channel. \n
    /// D3D counterpart: DXGI_FORMAT_B8G8R8A8_UNORM.
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_BGRA8_UNORM,

    /// Four-component 32-bit unsigned-normalized-integer format with 8 bits for each color channel and 8 bits unused. \n
    /// D3D counterpart: DXGI_FORMAT_B8G8R8X8_UNORM.
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_BGRX8_UNORM,

    /// Four-component 32-bit 2.8-biased fixed-point format with 10 bits for each color channel and 2-bit alpha. \n
    /// D3D counterpart: DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM.
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_R10G10B10_XR_BIAS_A2_UNORM,

    /// Four-component 32-bit typeless format with 8 bits for each channel. \n
    /// D3D counterpart: DXGI_FORMAT_B8G8R8A8_TYPELESS.
    /// \warning This format is not available in OpenGL
    TEX_FORMAT_BGRA8_TYPELESS,

    /// Four-component 32-bit unsigned-normalized sRGB format with 8 bits for each channel. \n
    /// D3D counterpart: DXGI_FORMAT_B8G8R8A8_UNORM_SRGB.
    /// \warning This format is not available in OpenGL.
    TEX_FORMAT_BGRA8_UNORM_SRGB,

    /// Four-component 32-bit typeless format that with 8 bits for each color channel, and 8 bits are unused. \n
    /// D3D counterpart: DXGI_FORMAT_B8G8R8X8_TYPELESS.
    /// \warning This format is not available in OpenGL.
    TEX_FORMAT_BGRX8_TYPELESS,

    /// Four-component 32-bit unsigned-normalized sRGB format with 8 bits for each color channel, and 8 bits are unused. \n
    /// D3D counterpart: DXGI_FORMAT_B8G8R8X8_UNORM_SRGB.
    /// \warning This format is not available in OpenGL.
    TEX_FORMAT_BGRX8_UNORM_SRGB,

    /// Three-component typeless block-compression format. \n
    /// D3D counterpart: DXGI_FORMAT_BC6H_TYPELESS. OpenGL does not have direct counterpart, GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT is used. \n
    /// [GL_ARB_texture_compression_bptc]: https://www.khronos.org/registry/OpenGL/extensions/ARB/ARB_texture_compression_bptc.txt
    /// OpenGL: [GL_ARB_texture_compression_bptc][] extension is required. Not supported in at least OpenGLES3.1
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d11/bc6h-format">BC6H on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/BPTC_Texture_Compression">BPTC Texture Compression on OpenGL.org </a>
    TEX_FORMAT_BC6H_TYPELESS,

    /// Three-component unsigned half-precision floating-point format with 16 bits for each channel. \n
    /// D3D counterpart: DXGI_FORMAT_BC6H_UF16. OpenGL counterpart: GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT. \n
    /// [GL_ARB_texture_compression_bptc]: https://www.khronos.org/registry/OpenGL/extensions/ARB/ARB_texture_compression_bptc.txt
    /// OpenGL: [GL_ARB_texture_compression_bptc][] extension is required. Not supported in at least OpenGLES3.1
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d11/bc6h-format">BC6H on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/BPTC_Texture_Compression">BPTC Texture Compression on OpenGL.org </a>
    TEX_FORMAT_BC6H_UF16,

    /// Three-channel signed half-precision floating-point format with 16 bits per each channel. \n
    /// D3D counterpart: DXGI_FORMAT_BC6H_SF16. OpenGL counterpart: GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT. \n
    /// [GL_ARB_texture_compression_bptc]: https://www.khronos.org/registry/OpenGL/extensions/ARB/ARB_texture_compression_bptc.txt
    /// OpenGL: [GL_ARB_texture_compression_bptc][] extension is required. Not supported in at least OpenGLES3.1
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d11/bc6h-format">BC6H on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/BPTC_Texture_Compression">BPTC Texture Compression on OpenGL.org </a>
    TEX_FORMAT_BC6H_SF16,

    /// Three-component typeless block-compression format. \n
    /// D3D counterpart: DXGI_FORMAT_BC7_TYPELESS. OpenGL does not have direct counterpart, GL_COMPRESSED_RGBA_BPTC_UNORM is used. \n
    /// [GL_ARB_texture_compression_bptc]: https://www.khronos.org/registry/OpenGL/extensions/ARB/ARB_texture_compression_bptc.txt
    /// OpenGL: [GL_ARB_texture_compression_bptc][] extension is required. Not supported in at least OpenGLES3.1
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d11/bc7-format">BC7 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/BPTC_Texture_Compression">BPTC Texture Compression on OpenGL.org </a>
    TEX_FORMAT_BC7_TYPELESS,

    /// Three-component block-compression unsigned-normalized-integer format with 4 to 7 bits per color channel and 0 to 8 bits of alpha. \n
    /// D3D counterpart: DXGI_FORMAT_BC7_UNORM. OpenGL counterpart: GL_COMPRESSED_RGBA_BPTC_UNORM. \n
    /// [GL_ARB_texture_compression_bptc]: https://www.khronos.org/registry/OpenGL/extensions/ARB/ARB_texture_compression_bptc.txt
    /// OpenGL: [GL_ARB_texture_compression_bptc][] extension is required. Not supported in at least OpenGLES3.1
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d11/bc7-format">BC7 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/BPTC_Texture_Compression">BPTC Texture Compression on OpenGL.org </a>
    TEX_FORMAT_BC7_UNORM,

    /// Three-component block-compression unsigned-normalized-integer sRGB format with 4 to 7 bits per color channel and 0 to 8 bits of alpha. \n
    /// D3D counterpart: DXGI_FORMAT_BC7_UNORM_SRGB. OpenGL counterpart: GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM. \n
    /// [GL_ARB_texture_compression_bptc]: https://www.khronos.org/registry/OpenGL/extensions/ARB/ARB_texture_compression_bptc.txt
    /// OpenGL: [GL_ARB_texture_compression_bptc][] extension is required. Not supported in at least OpenGLES3.1
    /// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/direct3d11/bc7-format">BC7 on MSDN </a>, 
    ///     <a href = "https://www.opengl.org/wiki/BPTC_Texture_Compression">BPTC Texture Compression on OpenGL.org </a>
    TEX_FORMAT_BC7_UNORM_SRGB,

    /// Helper member containing the total number of texture formats in the enumeration
    TEX_FORMAT_NUM_FORMATS
}

/// Filter type

/// This enumeration defines filter type. It is used by SamplerDesc structure to define min, mag and mip filters.
/// \note On D3D11, comparison filters only work with textures that have the following formats: 
/// R32_FLOAT_X8X24_TYPELESS, R32_FLOAT, R24_UNORM_X8_TYPELESS, R16_UNORM.
enum FILTER_TYPE : ubyte
{
    FILTER_TYPE_UNKNOWN  = 0,           ///< Unknown filter type
    FILTER_TYPE_POINT,                  ///< Point filtering
    FILTER_TYPE_LINEAR,                 ///< Linear filtering
    FILTER_TYPE_ANISOTROPIC,            ///< Anisotropic filtering
    FILTER_TYPE_COMPARISON_POINT,       ///< Comparison-point filtering
    FILTER_TYPE_COMPARISON_LINEAR,      ///< Comparison-linear filtering
    FILTER_TYPE_COMPARISON_ANISOTROPIC, ///< Comparison-anisotropic filtering
    FILTER_TYPE_MINIMUM_POINT,          ///< Minimum-point filtering (DX12 only)
    FILTER_TYPE_MINIMUM_LINEAR,         ///< Minimum-linear filtering (DX12 only)
    FILTER_TYPE_MINIMUM_ANISOTROPIC,    ///< Minimum-anisotropic filtering (DX12 only)
    FILTER_TYPE_MAXIMUM_POINT,          ///< Maximum-point filtering (DX12 only)
    FILTER_TYPE_MAXIMUM_LINEAR,         ///< Maximum-linear filtering (DX12 only)
    FILTER_TYPE_MAXIMUM_ANISOTROPIC,    ///< Maximum-anisotropic filtering (DX12 only)
    FILTER_TYPE_NUM_FILTERS             ///< Helper value that stores the total number of filter types in the enumeration
}

/// Texture address mode

/// [D3D11_TEXTURE_ADDRESS_MODE]: https://docs.microsoft.com/en-us/windows/win32/api/d3d11/ne-d3d11-d3d11_texture_address_mode
/// [D3D12_TEXTURE_ADDRESS_MODE]: https://docs.microsoft.com/en-us/windows/win32/api/d3d12/ne-d3d12-d3d12_texture_address_mode
/// Defines a technique for resolving texture coordinates that are outside of 
/// the boundaries of a texture. The enumeration generally mirrors [D3D11_TEXTURE_ADDRESS_MODE][]/[D3D12_TEXTURE_ADDRESS_MODE][] enumeration. 
/// It is used by SamplerDesc structure to define the address mode for U,V and W texture coordinates.
enum TEXTURE_ADDRESS_MODE : ubyte
{
    /// Unknown mode
    TEXTURE_ADDRESS_UNKNOWN = 0,

    /// Tile the texture at every integer junction. \n
    /// Direct3D Counterpart: D3D11_TEXTURE_ADDRESS_WRAP/D3D12_TEXTURE_ADDRESS_MODE_WRAP. OpenGL counterpart: GL_REPEAT
    TEXTURE_ADDRESS_WRAP    = 1,

    /// Flip the texture at every integer junction. \n
    /// Direct3D Counterpart: D3D11_TEXTURE_ADDRESS_MIRROR/D3D12_TEXTURE_ADDRESS_MODE_MIRROR. OpenGL counterpart: GL_MIRRORED_REPEAT
    TEXTURE_ADDRESS_MIRROR  = 2,

    /// Texture coordinates outside the range [0.0, 1.0] are set to the 
    /// texture color at 0.0 or 1.0, respectively. \n
    /// Direct3D Counterpart: D3D11_TEXTURE_ADDRESS_CLAMP/D3D12_TEXTURE_ADDRESS_MODE_CLAMP. OpenGL counterpart: GL_CLAMP_TO_EDGE
    TEXTURE_ADDRESS_CLAMP   = 3,

    /// Texture coordinates outside the range [0.0, 1.0] are set to the border color
    /// specified in SamplerDesc structure. \n
    /// Direct3D Counterpart: D3D11_TEXTURE_ADDRESS_BORDER/D3D12_TEXTURE_ADDRESS_MODE_BORDER. OpenGL counterpart: GL_CLAMP_TO_BORDER
    TEXTURE_ADDRESS_BORDER  = 4,

    /// Similar to TEXTURE_ADDRESS_MIRROR and TEXTURE_ADDRESS_CLAMP. Takes the absolute 
    /// value of the texture coordinate (thus, mirroring around 0), and then clamps to 
    /// the maximum value. \n
    /// Direct3D Counterpart: D3D11_TEXTURE_ADDRESS_MIRROR_ONCE/D3D12_TEXTURE_ADDRESS_MODE_MIRROR_ONCE. OpenGL counterpart: GL_MIRROR_CLAMP_TO_EDGE
    /// \note GL_MIRROR_CLAMP_TO_EDGE is only available in OpenGL4.4+, and is not available until at least OpenGLES3.1
    TEXTURE_ADDRESS_MIRROR_ONCE = 5,

    /// Helper value that stores the total number of texture address modes in the enumeration
    TEXTURE_ADDRESS_NUM_MODES
}

/// Comparison function

/// [D3D11_COMPARISON_FUNC]: https://docs.microsoft.com/en-us/windows/win32/api/d3d11/ne-d3d11-d3d11_comparison_func
/// [D3D12_COMPARISON_FUNC]: https://docs.microsoft.com/en-us/windows/win32/api/d3d12/ne-d3d12-d3d12_comparison_func
/// This enumeartion defines a comparison function. It generally mirrors [D3D11_COMPARISON_FUNC]/[D3D12_COMPARISON_FUNC] enum and is used by
/// - SamplerDesc to define a comparison function if one of the comparison mode filters is used
/// - StencilOpDesc to define a stencil function
/// - DepthStencilStateDesc to define a depth function
enum COMPARISON_FUNCTION : ubyte
{
    /// Unknown comparison function
    COMPARISON_FUNC_UNKNOWN = 0,

    /// Comparison never passes. \n
    /// Direct3D counterpart: D3D11_COMPARISON_NEVER/D3D12_COMPARISON_FUNC_NEVER. OpenGL counterpart: GL_NEVER.
    COMPARISON_FUNC_NEVER,

    /// Comparison passes if the source data is less than the destination data.\n
    /// Direct3D counterpart: D3D11_COMPARISON_LESS/D3D12_COMPARISON_FUNC_LESS. OpenGL counterpart: GL_LESS.
    COMPARISON_FUNC_LESS,

    /// Comparison passes if the source data is equal to the destination data.\n
    /// Direct3D counterpart: D3D11_COMPARISON_EQUAL/D3D12_COMPARISON_FUNC_EQUAL. OpenGL counterpart: GL_EQUAL.
    COMPARISON_FUNC_EQUAL,

    /// Comparison passes if the source data is less than or equal to the destination data.\n
    /// Direct3D counterpart: D3D11_COMPARISON_LESS_EQUAL/D3D12_COMPARISON_FUNC_LESS_EQUAL. OpenGL counterpart: GL_LEQUAL.
    COMPARISON_FUNC_LESS_EQUAL,

    /// Comparison passes if the source data is greater than the destination data.\n
    /// Direct3D counterpart: 3D11_COMPARISON_GREATER/D3D12_COMPARISON_FUNC_GREATER. OpenGL counterpart: GL_GREATER.
    COMPARISON_FUNC_GREATER,

    /// Comparison passes if the source data is not equal to the destination data.\n
    /// Direct3D counterpart: D3D11_COMPARISON_NOT_EQUAL/D3D12_COMPARISON_FUNC_NOT_EQUAL. OpenGL counterpart: GL_NOTEQUAL.
    COMPARISON_FUNC_NOT_EQUAL,

    /// Comparison passes if the source data is greater than or equal to the destination data.\n
    /// Direct3D counterpart: D3D11_COMPARISON_GREATER_EQUAL/D3D12_COMPARISON_FUNC_GREATER_EQUAL. OpenGL counterpart: GL_GEQUAL.
    COMPARISON_FUNC_GREATER_EQUAL,

    /// Comparison always passes. \n
    /// Direct3D counterpart: D3D11_COMPARISON_ALWAYS/D3D12_COMPARISON_FUNC_ALWAYS. OpenGL counterpart: GL_ALWAYS.
    COMPARISON_FUNC_ALWAYS,

    /// Helper value that stores the total number of comparison functions in the enumeration
    COMPARISON_FUNC_NUM_FUNCTIONS
}

/// Miscellaneous texture flags

/// The enumeration is used by TextureDesc to describe misc texture flags
enum MISC_TEXTURE_FLAGS : ubyte
{
    MISC_TEXTURE_FLAG_NONE          = 0x00,

    /// Allow automatic mipmap generation with ITextureView::GenerateMips()

    /// \note A texture must be created with BIND_RENDER_TARGET bind flag
    MISC_TEXTURE_FLAG_GENERATE_MIPS = 0x01,

    /// The texture will be used as a transient framebuffer attachment.

    /// \note Memoryless textures must only be used within a render passes in a framebuffer,
    ///       load operation must be CLEAR or DISCARD, store operation must be DISCARD.
    MISC_TEXTURE_FLAG_MEMORYLESS    = 0x02,
}

/// Input primitive topology.

/// This enumeration is used by GraphicsPipelineDesc structure to define input primitive topology.
enum PRIMITIVE_TOPOLOGY : ubyte
{
    /// Undefined topology
    PRIMITIVE_TOPOLOGY_UNDEFINED = 0,

    /// Interpret the vertex data as a list of triangles.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST. OpenGL counterpart: GL_TRIANGLES.
    PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,

    /// Interpret the vertex data as a triangle strip.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP. OpenGL counterpart: GL_TRIANGLE_STRIP.
    PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP,

    /// Interpret the vertex data as a list of points.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_POINTLIST. OpenGL counterpart: GL_POINTS.
    PRIMITIVE_TOPOLOGY_POINT_LIST,

    /// Interpret the vertex data as a list of lines.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_LINELIST. OpenGL counterpart: GL_LINES.
    PRIMITIVE_TOPOLOGY_LINE_LIST,

    /// Interpret the vertex data as a line strip.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_LINESTRIP. OpenGL counterpart: GL_LINE_STRIP.
    PRIMITIVE_TOPOLOGY_LINE_STRIP,

    /// Interpret the vertex data as a list of one control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_1_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_1_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of two control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_2_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_2_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of three control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_3_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_3_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of four control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_4_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of five control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_5_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_5_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of six control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_6_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_6_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of seven control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_7_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_7_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of eight control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_8_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_8_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of nine control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_9_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_9_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of ten control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_10_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_10_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 11 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_11_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_11_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 12 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_12_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_12_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 13 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_13_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_13_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 14 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_14_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_14_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 15 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_15_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_15_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 16 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_16_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_16_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 17 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_17_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_17_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 18 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_18_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_18_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 19 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_19_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_19_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 20 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_20_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_20_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 21 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_21_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_21_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 22 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_22_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_22_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 23 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_23_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_23_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 24 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_24_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_24_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 25 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_25_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_25_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 26 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_26_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_26_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 27 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_27_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_27_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 28 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_28_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_28_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 29 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_29_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_29_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 30 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_30_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_30_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 31 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_31_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_31_CONTROL_POINT_PATCHLIST,

    /// Interpret the vertex data as a list of 32 control point patches.\n
    /// D3D counterpart: D3D_PRIMITIVE_TOPOLOGY_32_CONTROL_POINT_PATCHLIST. OpenGL counterpart: GL_PATCHES.
    PRIMITIVE_TOPOLOGY_32_CONTROL_POINT_PATCHLIST,

    /// Helper value that stores the total number of topologies in the enumeration
    PRIMITIVE_TOPOLOGY_NUM_TOPOLOGIES
}

/// Memory property flags.
enum MEMORY_PROPERTIES : uint
{
    /// Memory properties are unknown.
    MEMORY_PROPERTY_UNKNOWN       = 0x00,

    /// The device (GPU) memory is coherent with the host (CPU), meaning
    /// that CPU writes are automatically available to the GPU and vice versa.
    /// If memory is not coherent, it must be explicitly flushed after
    /// being modified by the CPU, or invalidated before being read by the CPU.
    ///
    /// \sa IBuffer::GetMemoryProperties().
    MEMORY_PROPERTY_HOST_COHERENT = 0x01
}

/// Defines optimized depth-stencil clear value.
struct DepthStencilClearValue
{
    /// Depth clear value
    float Depth = 1.0F;
    /// Stencil clear value
    ubyte Stencil = 0;
}

/// Defines optimized clear value.
struct OptimizedClearValue
{
    /// Format
    TEXTURE_FORMAT Format = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// Render target clear value
    float[4] Color = [];

    /// Depth stencil clear value
    DepthStencilClearValue DepthStencil;
}

/// Describes common device object attributes
struct DeviceObjectAttribs
{
    /// Object name
    const(char)* Name = null;    
}
    
/// Hardware adapter type
enum ADAPTER_TYPE : ubyte
{
    /// Adapter type is unknown
    ADAPTER_TYPE_UNKNOWN = 0,

    /// Software adapter
    ADAPTER_TYPE_SOFTWARE,

    /// Integrated hardware adapter
    ADAPTER_TYPE_INTEGRATED,

    /// Discrete hardware adapter
    ADAPTER_TYPE_DISCRETE,
}

/// Flags indicating how an image is stretched to fit a given monitor's resolution.
/// \sa <a href = "https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173066(v=vs.85)">DXGI_MODE_SCALING enumeration on MSDN</a>, 
enum SCALING_MODE
{
    /// Unspecified scaling.
    /// D3D Counterpart: DXGI_MODE_SCALING_UNSPECIFIED.
    SCALING_MODE_UNSPECIFIED = 0,

    /// Specifies no scaling. The image is centered on the display. 
    /// This flag is typically used for a fixed-dot-pitch display (such as an LED display).
    /// D3D Counterpart: DXGI_MODE_SCALING_CENTERED.
    SCALING_MODE_CENTERED = 1,

    /// Specifies stretched scaling.
    /// D3D Counterpart: DXGI_MODE_SCALING_STRETCHED.
    SCALING_MODE_STRETCHED = 2
}

/// Flags indicating the method the raster uses to create an image on a surface.
/// \sa <a href = "https://docs.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173067(v=vs.85)">DXGI_MODE_SCANLINE_ORDER enumeration on MSDN</a>, 
enum SCANLINE_ORDER
{
    /// Scanline order is unspecified
    /// D3D Counterpart: DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED.
    SCANLINE_ORDER_UNSPECIFIED = 0,

    /// The image is created from the first scanline to the last without skipping any
    /// D3D Counterpart: DXGI_MODE_SCANLINE_ORDER_PROGRESSIVE.
    SCANLINE_ORDER_PROGRESSIVE = 1,

    /// The image is created beginning with the upper field
    /// D3D Counterpart: DXGI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST.
    SCANLINE_ORDER_UPPER_FIELD_FIRST = 2,

    /// The image is created beginning with the lower field
    /// D3D Counterpart: DXGI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST.
    SCANLINE_ORDER_LOWER_FIELD_FIRST = 3
}

/// Display mode attributes
struct DisplayModeAttribs
{
    /// Display resolution width
    uint Width = 0;

    /// Display resolution height
    uint Height = 0;

    /// Display format
    TEXTURE_FORMAT Format = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// Refresh rate numerator
    uint RefreshRateNumerator = 0;

    /// Refresh rate denominator
    uint RefreshRateDenominator = 0;

    /// The scanline drawing mode. 
    enum SCALING_MODE Scaling = SCALING_MODE.SCALING_MODE_UNSPECIFIED;

    /// The scaling mode. 
    enum SCANLINE_ORDER ScanlineOrder = SCANLINE_ORDER.SCANLINE_ORDER_UNSPECIFIED;
}

/// Defines allowed swap chain usage flags
enum SWAP_CHAIN_USAGE_FLAGS : uint
{
    /// No allowed usage
    SWAP_CHAIN_USAGE_NONE             = 0x00L,
        
    /// Swap chain can be used as render target output
    SWAP_CHAIN_USAGE_RENDER_TARGET    = 0x01L,

    /// Swap chain images can be used as shader inputs
    SWAP_CHAIN_USAGE_SHADER_INPUT     = 0x02L,

    /// Swap chain images can be used as source of copy operation
    SWAP_CHAIN_USAGE_COPY_SOURCE      = 0x04L,

    SWAP_CHAIN_USAGE_LAST             = SWAP_CHAIN_USAGE_COPY_SOURCE,
}

/// The transform applied to the image content prior to presentation.
enum SURFACE_TRANSFORM : uint
{
    /// Uset the most optimal surface transform.
    SURFACE_TRANSFORM_OPTIMAL = 0,

    /// The image content is presented without being transformed.
    SURFACE_TRANSFORM_IDENTITY,

    /// The image content is rotated 90 degrees clockwise.
    SURFACE_TRANSFORM_ROTATE_90,

    /// The image content is rotated 180 degrees clockwise.
    SURFACE_TRANSFORM_ROTATE_180,

    /// The image content is rotated 270 degrees clockwise.
    SURFACE_TRANSFORM_ROTATE_270,

    /// The image content is mirrored horizontally.
    SURFACE_TRANSFORM_HORIZONTAL_MIRROR,

    /// The image content is mirrored horizontally, then rotated 90 degrees clockwise.
    SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90,

    /// The  image content is mirrored horizontally, then rotated 180 degrees clockwise.
    SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180,

    /// The  image content is mirrored horizontally, then rotated 270 degrees clockwise.
    SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270
}

/// Swap chain description
struct SwapChainDesc
{
    /// The swap chain width. Default value is 0
    uint Width = 0;

    /// The swap chain height. Default value is 0
    uint Height = 0;
        
    /// Back buffer format. Default value is Diligent::TEX_FORMAT_RGBA8_UNORM_SRGB
    TEXTURE_FORMAT ColorBufferFormat = TEXTURE_FORMAT.TEX_FORMAT_RGBA8_UNORM_SRGB;
        
    /// Depth buffer format. Default value is Diligent::TEX_FORMAT_D32_FLOAT.
    /// Use Diligent::TEX_FORMAT_UNKNOWN to create the swap chain without depth buffer.
    TEXTURE_FORMAT DepthBufferFormat = TEXTURE_FORMAT.TEX_FORMAT_D32_FLOAT;

    /// Swap chain usage flags. Default value is Diligent::SWAP_CHAIN_USAGE_RENDER_TARGET
    SWAP_CHAIN_USAGE_FLAGS Usage = SWAP_CHAIN_USAGE_FLAGS.SWAP_CHAIN_USAGE_RENDER_TARGET;

    /// The transform, relative to the presentation engine's natural orientation,
    /// applied to the image content prior to presentation.
    ///
    /// \note When default value (SURFACE_TRANSFORM_OPTIMAL) is used, the engine will
    ///       select the most optimal surface transformation. An application may request
    ///       specific transform (e.g. SURFACE_TRANSFORM_IDENTITY) and the engine will
    ///       try to use that. However, if the transform is not available, the engine will
    ///       select the most optimal transform.
    ///       After the swap chain has been created, this member will contain the actual
    ///       transform selected by the engine and can be queried through ISwapChain::GetDesc()
    ///       method.
    SURFACE_TRANSFORM PreTransform = SURFACE_TRANSFORM.SURFACE_TRANSFORM_OPTIMAL;

    /// The number of buffers in the swap chain
    uint BufferCount = 2;
    
    /// Default depth value, which is used as optimized depth clear value in D3D12
    float DefaultDepthValue = 1.0F;

    /// Default stencil value, which is used as optimized stencil clear value in D3D12
    ubyte DefaultStencilValue = 0;

    /// Indicates if this is a primary swap chain. When Present() is called
    /// for the primary swap chain, the engine releases stale resources.
    bool  IsPrimary = true;
}

/// Full screen mode description
/// \sa <a href = "https://docs.microsoft.com/en-us/windows/win32/api/dxgi1_2/ns-dxgi1_2-dxgi_swap_chain_fullscreen_desc">DXGI_SWAP_CHAIN_FULLSCREEN_DESC structure on MSDN</a>, 
struct FullScreenModeDesc
{
    /// A Boolean value that specifies whether the swap chain is in fullscreen mode.
    bool Fullscreen = false;

    /// Refresh rate numerator
    uint RefreshRateNumerator = 0;

    /// Refresh rate denominator
    uint RefreshRateDenominator = 0;

    /// The scanline drawing mode. 
    enum SCALING_MODE    Scaling = SCALING_MODE.SCALING_MODE_UNSPECIFIED;

    /// The scaling mode. 
    enum SCANLINE_ORDER  ScanlineOrder = SCANLINE_ORDER.SCANLINE_ORDER_UNSPECIFIED;
}

/// Query type.
enum QUERY_TYPE
{
    /// Query type is undefined.
    QUERY_TYPE_UNDEFINED = 0,

    /// Gets the number of samples that passed the depth and stencil tests in between IDeviceContext::BeginQuery
    /// and IDeviceContext::EndQuery. IQuery::GetData fills a Diligent::QueryDataOcclusion struct.
    QUERY_TYPE_OCCLUSION,

    /// Acts like QUERY_TYPE_OCCLUSION except that it returns simply a binary true/false result: false indicates that no samples
    /// passed depth and stencil testing, true indicates that at least one sample passed depth and stencil testing.
    /// IQuery::GetData fills a Diligent::QueryDataBinaryOcclusion struct.
    QUERY_TYPE_BINARY_OCCLUSION,

    /// Gets the GPU timestamp corresponding to IDeviceContext::EndQuery call. For this query
    /// type IDeviceContext::BeginQuery is disabled. IQuery::GetData fills a Diligent::QueryDataTimestamp struct.
    QUERY_TYPE_TIMESTAMP,

    /// Gets pipeline statistics, such as the number of pixel shader invocations in between IDeviceContext::BeginQuery
    /// and IDeviceContext::EndQuery. IQuery::GetData fills a Diligent::QueryDataPipelineStatistics struct.
    QUERY_TYPE_PIPELINE_STATISTICS,

    /// Gets the number of high-frequency counter ticks between IDeviceContext::BeginQuery and
    /// IDeviceContext::EndQuery calls. IQuery::GetData fills a Diligent::QueryDataDuration struct.
    QUERY_TYPE_DURATION,

    /// The number of query types in the enum
    QUERY_TYPE_NUM_TYPES
}

/// Device type
enum RENDER_DEVICE_TYPE
{
    RENDER_DEVICE_TYPE_UNDEFINED = 0,  ///< Undefined device
    RENDER_DEVICE_TYPE_D3D11,          ///< D3D11 device
    RENDER_DEVICE_TYPE_D3D12,          ///< D3D12 device
    RENDER_DEVICE_TYPE_GL,             ///< OpenGL device 
    RENDER_DEVICE_TYPE_GLES,           ///< OpenGLES device
    RENDER_DEVICE_TYPE_VULKAN,         ///< Vulkan device
    RENDER_DEVICE_TYPE_METAL,          ///< Metal device
    RENDER_DEVICE_TYPE_COUNT           ///< The total number of device types
}

/// Device feature state
enum DEVICE_FEATURE_STATE : ubyte
{
    /// Device feature is disabled.
    DEVICE_FEATURE_STATE_DISABLED = 0,

    /// Device feature is enabled.

    /// If a feature is requested to be enabled during the initialization through
    /// EngineCreateInfo::Features, but is not supported by the device/driver/platform,
    /// the engine will fail to initialize.
    DEVICE_FEATURE_STATE_ENABLED = 1,

    /// Device feature is optional. 

    /// During the initialization the engine will attempt to enable the feature.
    /// If the feature is not supported by the device/driver/platform,
    /// the engine will successfully be initialized, but the feature will be disabled.
    /// The actual feature state can be queried from DeviceCaps structure.
    DEVICE_FEATURE_STATE_OPTIONAL = 2
}

/// Describes the device features
struct DeviceFeatures
{
    /// Indicates if device supports separable shader programs.

    /// \remarks    The only case when separable programs are not supported is when the engine is 
    ///             initialized in GLES3.0 mode. In GLES3.1+ and in all other backends, the
    ///             feature is always enabled.
    ///             The are two main limitations when separable programs are disabled:
    ///             - If the same shader variable is present in multiple shader stages,
    ///               it will always be shared between all stages and different resources
    ///               can't be bound to different stages.
    ///             - Shader resource queries will be also disabled.
    DEVICE_FEATURE_STATE SeparablePrograms = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports resource queries from shader objects.

    /// \ note  This feature indicates if IShader::GetResourceCount() and IShader::GetResourceDesc() methods
    ///         can be used to query the list of resources of individual shader objects.
    ///         Shader variable queries from pipeline state and shader resource binding objects are always
    ///         available.
    ///
    ///         The feature is always enabled in Direct3D11, Direct3D12 and Vulkan. It is enabled in
    ///         OpenGL when separable programs are available, and it is always disabled in Metal.
    DEVICE_FEATURE_STATE ShaderResourceQueries = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports indirect draw commands
    DEVICE_FEATURE_STATE IndirectRendering = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports wireframe fill mode
    DEVICE_FEATURE_STATE WireframeFill = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports multithreaded resource creation
    DEVICE_FEATURE_STATE MultithreadedResourceCreation = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports compute shaders
    DEVICE_FEATURE_STATE ComputeShaders = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports geometry shaders
    DEVICE_FEATURE_STATE GeometryShaders = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports tessellation
    DEVICE_FEATURE_STATE Tessellation = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports mesh and amplification shaders
    DEVICE_FEATURE_STATE MeshShaders = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports ray tracing.
    /// See Diligent::RayTracingProperties for more information.
    DEVICE_FEATURE_STATE RayTracing = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports bindless resources
    DEVICE_FEATURE_STATE BindlessResources = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports occlusion queries (see Diligent::QUERY_TYPE_OCCLUSION).
    DEVICE_FEATURE_STATE OcclusionQueries = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports binary occlusion queries (see Diligent::QUERY_TYPE_BINARY_OCCLUSION).
    DEVICE_FEATURE_STATE BinaryOcclusionQueries = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports timestamp queries (see Diligent::QUERY_TYPE_TIMESTAMP).
    DEVICE_FEATURE_STATE TimestampQueries = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports pipeline statistics queries (see Diligent::QUERY_TYPE_PIPELINE_STATISTICS).
    DEVICE_FEATURE_STATE PipelineStatisticsQueries = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports duration queries (see Diligent::QUERY_TYPE_DURATION).
    DEVICE_FEATURE_STATE DurationQueries = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports depth bias clamping
    DEVICE_FEATURE_STATE DepthBiasClamp = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports depth clamping
    DEVICE_FEATURE_STATE DepthClamp = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports depth clamping
    DEVICE_FEATURE_STATE IndependentBlend = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports dual-source blend
    DEVICE_FEATURE_STATE DualSourceBlend = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports multiviewport
    DEVICE_FEATURE_STATE MultiViewport = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports all BC-compressed formats
    DEVICE_FEATURE_STATE TextureCompressionBC = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports writes to UAVs as well as atomic operations in vertex,
    /// tessellation, and geometry shader stages.
    DEVICE_FEATURE_STATE VertexPipelineUAVWritesAndAtomics = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports writes to UAVs as well as atomic operations in pixel
    /// shader stage.
    DEVICE_FEATURE_STATE PixelUAVWritesAndAtomics = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Specifies whether all the extended UAV texture formats are available in shader code.
    DEVICE_FEATURE_STATE TextureUAVExtendedFormats = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports native 16-bit float operations. Note that there are separate features
    /// that indicate if device supports loading 16-bit floats from buffers and passing them between shader stages.
    /// 
    /// \note   16-bit support is quite tricky, the following post should help understand it better:
    ///         https://therealmjp.github.io/posts/shader-fp16/
    DEVICE_FEATURE_STATE ShaderFloat16 = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports reading and writing 16-bit floats and ints from buffers bound
    /// as shader resource or unordered access views.
    DEVICE_FEATURE_STATE ResourceBuffer16BitAccess = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports reading 16-bit floats and ints from uniform buffers.
    DEVICE_FEATURE_STATE UniformBuffer16BitAccess = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if 16-bit floats and ints can be used as input/output of a shader entry point.
    DEVICE_FEATURE_STATE ShaderInputOutput16 = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports native 8-bit integer operations.
    DEVICE_FEATURE_STATE ShaderInt8 = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports reading and writing 8-bit types from buffers bound
    /// as shader resource or unordered access views.
    DEVICE_FEATURE_STATE ResourceBuffer8BitAccess = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports reading 8-bit types from uniform buffers.
    DEVICE_FEATURE_STATE UniformBuffer8BitAccess = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports runtime-sized shader arrays (e.g. arrays without a specific size).
    ///
    /// \remarks    This feature is always enabled in DirectX12 backend and
    ///             can optionally be enabled in Vulkan backend.
    ///             Run-time sized shader arrays are not available in other backends.
    DEVICE_FEATURE_STATE ShaderResourceRuntimeArray = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports wave ops (Direct3D12) or subgroups (Vulkan).
    DEVICE_FEATURE_STATE WaveOp = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports instance data step rates other than 1.
    DEVICE_FEATURE_STATE InstanceDataStepRate = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device natively supports fence with Uint64 counter.
    /// Native fence can wait on GPU for a signal from CPU, can be enqueued for wait operation for any value.
    /// If not natively supported by the device, the fence is emulated where possible.
    DEVICE_FEATURE_STATE NativeFence = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports tile shaders.
    DEVICE_FEATURE_STATE TileShaders = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;

    /// Indicates if device supports timestamp and duration queries in transfer queues.
    DEVICE_FEATURE_STATE TransferQueueTimestampQueries = DEVICE_FEATURE_STATE.DEVICE_FEATURE_STATE_DISABLED;
}

/// Graphics adapter vendor
enum ADAPTER_VENDOR : ubyte
{
    /// Adapter vendor is unknown
    ADAPTER_VENDOR_UNKNOWN = 0,

    /// Adapter vendor is NVidia
    ADAPTER_VENDOR_NVIDIA,

    /// Adapter vendor is AMD
    ADAPTER_VENDOR_AMD,

    /// Adapter vendor is Intel
    ADAPTER_VENDOR_INTEL,

    /// Adapter vendor is ARM
    ADAPTER_VENDOR_ARM,

    /// Adapter vendor is Qualcomm
    ADAPTER_VENDOR_QUALCOMM,

    /// Adapter vendor is Imagination Technologies
    ADAPTER_VENDOR_IMGTECH,

    /// Adapter vendor is Microsoft (software rasterizer)
    ADAPTER_VENDOR_MSFT,

    /// Adapter vendor is Apple
    ADAPTER_VENDOR_APPLE,

    /// Adapter vendor is Mesa (software rasterizer)
    ADAPTER_VENDOR_MESA,

    /// Adapter vendor is Broadcom (Raspberry Pi)
    ADAPTER_VENDOR_BROADCOM,

    ADAPTER_VENDOR_LAST = ADAPTER_VENDOR_BROADCOM
}

/// Version
struct Version
{
    /// Major revision
    uint Major = 0;

    /// Minor revision
    uint Minor = 0;
}

/// Describes the wave feature types.
/// In Vulkan backend, you should check which features are supported by device.
/// In Direct3D12 backend, all shader model 6.0 wave functions are supported if WaveOp feature is enabled.
/// see doc/WaveOp.md
enum WAVE_FEATURE : uint
{
    WAVE_FEATURE_UNKNOWN          = 0x00,
    WAVE_FEATURE_BASIC            = 0x01,
    WAVE_FEATURE_VOTE             = 0x02,
    WAVE_FEATURE_ARITHMETIC       = 0x04,
    WAVE_FEATURE_BALLOUT          = 0x08,
    WAVE_FEATURE_SHUFFLE          = 0x10,
    WAVE_FEATURE_SHUFFLE_RELATIVE = 0x20,
    WAVE_FEATURE_CLUSTERED        = 0x40,
    WAVE_FEATURE_QUAD             = 0x80,
    WAVE_FEATURE_LAST             = WAVE_FEATURE_QUAD
}

/// Common validation levels that translate to specific settings for different backends.
enum VALIDATION_LEVEL : ubyte
{
    /// Validation is disabled.
    VALIDATION_LEVEL_DISABLED = 0,

    /// Standard validation options are enabled.
    VALIDATION_LEVEL_1,

    /// All validation options are enabled.
    /// Note that enabling this level may add a significant overhead.
    VALIDATION_LEVEL_2
}

/// Texture properites
struct TextureProperties
{
    /// Maximum dimension (width) of a 1D texture, or 0 if 1D textures are not supported.
    uint MaxTexture1DDimension = 0;

    /// Maximum number of slices in a 1D texture array, or 0 if 1D texture arrays are not supported.
    uint MaxTexture1DArraySlices = 0;

    /// Maximum dimension (width or height) of a 2D texture.
    uint MaxTexture2DDimension = 0;

    /// Maximum number of slices in a 2D texture array, or 0 if 2D texture arrays are not supported.
    uint MaxTexture2DArraySlices = 0;

    /// Maximum dimension (width, height, or depth) of a 3D texture, or 0 if 3D textures are not supported.
    uint MaxTexture3DDimension = 0;

    /// Maximum dimension (width or height) of a cubemap face, or 0 if cubemap textures are not supported.
    uint MaxTextureCubeDimension = 0;

    /// Indicates if device supports 2D multisampled textures
    bool Texture2DMSSupported = false;

    /// Indicates if device supports 2D multisampled texture arrays
    bool Texture2DMSArraySupported = false;

    /// Indicates if device supports texture views
    bool TextureViewSupported = false;

    /// Indicates if device supports cubemap arrays
    bool CubemapArraysSupported = false;
}

/// Texture sampler properties
struct SamplerProperties
{
    /// Indicates if device supports border texture addressing mode
    bool BorderSamplingModeSupported = false;

    /// Indicates if device supports anisotrpoic filtering
    bool AnisotropicFilteringSupported = false;

    /// Indicates if device supports MIP load bias
    bool LODBiasSupported = false;
}

/// Wave operation properties
struct WaveOpProperties
{
    /// Minimum supported size of the wave.
    uint       MinSize = 0;

    /// Maximum supported size of the wave.
    /// If variable wave size is not supported then this value is equal to MinSize.
    /// Direct3D12 backend: requires shader model 6.6.
    /// Vulkan backend: requires VK_EXT_subgroup_size_control.
    uint       MaxSize = 0;

    /// Shader stages in which wave operations can be used.
    SHADER_TYPE  SupportedStages = SHADER_TYPE.SHADER_TYPE_UNKNOWN;

    /// Indicates which groups of wave operations are supported by this device. 
    WAVE_FEATURE Features = WAVE_FEATURE.WAVE_FEATURE_UNKNOWN;
}

/// Buffer propertiess
struct BufferProperties
{
    /// The minimum required alignment, in bytes, for the constant buffer offsets.
    /// The Offset parameter passed to IShaderResourceVariable::SetBufferRange() or to
    /// IShaderResourceVariable::SetBufferOffset() method used to set the offset of a
    /// constant buffer, must be an integer multiple of this limit.
    uint ConstantBufferOffsetAlignment = 0;

    /// The minimum required alignment, in bytes, for the structured buffer offsets.
    /// The ByteOffset member of the BufferViewDesc used to create a structured buffer view or
    /// the Offset parameter passed to IShaderResourceVariable::SetBufferOffset() method used to
    /// set the offset of a structured buffer, must be an integer multiple of this limit.
    uint StructuredBufferOffsetAlignment = 0;
}

/// Ray tracing capability flags
enum RAY_TRACING_CAP_FLAGS : ubyte
{
    /// No ray-tracing capabilities
    RAY_TRACING_CAP_FLAG_NONE                 = 0x00,

    /// The device supports standalone ray tracing shaders (e.g. ray generation, closest hit, any hit, etc.)
    /// When this feature is disabled, inline ray tracing may still be supported where rays can be traced
    /// from graphics or compute shaders.
    RAY_TRACING_CAP_FLAG_STANDALONE_SHADERS   = 0x01,

    /// The device supports inline ray tracing in graphics or compute shaders.
    RAY_TRACING_CAP_FLAG_INLINE_RAY_TRACING   = 0x02,

    /// The device supports IDeviceContext::TraceRaysIndirect() command.
    RAY_TRACING_CAP_FLAG_INDIRECT_RAY_TRACING = 0x04
}

/// Ray tracing properties
struct RayTracingProperties
{
    /// Maximum supported value for RayTracingPipelineDesc::MaxRecursionDepth.
    uint MaxRecursionDepth = 0;

    /// For internal use
    uint ShaderGroupHandleSize = 0;
    uint MaxShaderRecordStride = 0;
    uint ShaderGroupBaseAlignment = 0;

    /// The maximum total number of ray generation threads in one dispatch.
    uint MaxRayGenThreads = 0;

    /// The maximum number of instances in a top-level AS.
    uint MaxInstancesPerTLAS = 0;

    /// The maximum number of primitives in a bottom-level AS.
    uint MaxPrimitivesPerBLAS = 0;

    /// The maximum number of geometries in a bottom-level AS.
    uint MaxGeometriesPerBLAS = 0;

    /// The minimum alignment for vertex buffer offset in BLASBuildTriangleData::VertexOffset.
    uint VertexBufferAlignmnent = 0;
    
    /// The minimum alignment for index buffer offset in BLASBuildTriangleData::IndexOffset.
    uint IndexBufferAlignment = 0;
    
    /// The minimum alignment for transform buffer offset in BLASBuildTriangleData::TransformBufferOffset.
    uint TransformBufferAlignment = 0;
    
    /// The minimum alignment for box buffer offset in BLASBuildBoundingBoxData::BoxOffset.
    uint BoxBufferAlignment = 0;
    
    /// The minimum alignment for scratch buffer offset in BuildBLASAttribs::ScratchBufferOffset and BuildTLASAttribs::ScratchBufferOffset.
    uint ScratchBufferAlignment = 0;
    
    /// The minimum alignment for instance buffer offset in BuildTLASAttribs::InstanceBufferOffset.
    uint InstanceBufferAlignment = 0;

    /// Ray tracing capability flags, see Diligent::RAY_TRACING_CAP_FLAGS.
    RAY_TRACING_CAP_FLAGS CapFlags = RAY_TRACING_CAP_FLAGS.RAY_TRACING_CAP_FLAG_NONE;
}

/// Mesh Shader Properties
struct MeshShaderProperties
{
    /// The maximum number of mesh shader tasks per draw command.
    uint MaxTaskCount = 0;
}

/// Compute Shader Properties
struct ComputeShaderProperties
{
    /// Amount of shared memory available to threads in one group.
    uint SharedMemorySize = 0;

    /// The total mamximum number of threads in one group.
    uint MaxThreadGroupInvocations = 0;

    /// The maximum number of threads in group X dimension.
    uint MaxThreadGroupSizeX = 0;
    /// The maximum number of threads in group Y dimension.
    uint MaxThreadGroupSizeY = 0;
    /// The maximum number of threads in group Z dimension.
    uint MaxThreadGroupSizeZ = 0;

    /// The maximum number of thread groups that can be dispatched
    /// in X dimension.
    uint MaxThreadGroupCountX = 0;
    /// The maximum number of thread groups that can be dispatched
    /// in Y dimension.
    uint MaxThreadGroupCountY = 0;
    /// The maximum number of thread groups that can be dispatched
    /// in Z dimension.
    uint MaxThreadGroupCountZ = 0;
}

/// Render device information
struct RenderDeviceInfo
{
    /// Device type. See Diligent::RENDER_DEVICE_TYPE.
    enum RENDER_DEVICE_TYPE Type = RENDER_DEVICE_TYPE.RENDER_DEVICE_TYPE_UNDEFINED;

    /// Major revision of the graphics API supported by the graphics adapter.
    /// Note that this value indicates the maximum supported feature level, so,
    /// for example, if the device type is D3D11, this value will be 10 when 
    /// the maximum supported Direct3D feature level of the graphics adapter is 10.0.
    Version APIVersion = {};

    /// Enabled device features. See Diligent::DeviceFeatures.

    /// \note For optional features requested during the initialization, the
    ///       struct will indicate the actual feature state (enabled or disabled).
    ///
    ///       The feature state in the adapter info indicates if the GPU supports the
    ///       feature, but if it is not enabled, an application must not use it.
    DeviceFeatures Features;
}

/// Commomn validation options.
enum VALIDATION_FLAGS : uint
{
    /// Extra validation is disabled.
    VALIDATION_FLAG_NONE                        = 0x00,

    /// Verify that constant or structured buffer size is not smaller than what is expected by the shader.
    ///
    /// \remarks  This flag only has effect in Debug/Development builds.
    ///           This type of validation is never performed in Release builds.
    ///
    /// \note   This option is currently supported by Vulkan backend only.
    VALIDATION_FLAG_CHECK_SHADER_BUFFER_SIZE    = 0x01
}

/// Command queue type
enum COMMAND_QUEUE_TYPE : ubyte
{
    /// Queue type is unknown.
    COMMAND_QUEUE_TYPE_UNKNOWN        = 0,

    /// Command queue that only supports memory transfer operations.
    COMMAND_QUEUE_TYPE_TRANSFER       = 0x01,

    /// Command queue that supports compute, ray tracing and transfer commands.
    COMMAND_QUEUE_TYPE_COMPUTE        = 0x02 | COMMAND_QUEUE_TYPE_TRANSFER,

    /// Command queue that supports graphics, compute, ray tracing and transfer commands.
    COMMAND_QUEUE_TYPE_GRAPHICS       = 0x04 | COMMAND_QUEUE_TYPE_COMPUTE,

    /// Mask to extract primary command queue type.
    COMMAND_QUEUE_TYPE_PRIMARY_MASK   = COMMAND_QUEUE_TYPE_TRANSFER | COMMAND_QUEUE_TYPE_COMPUTE | COMMAND_QUEUE_TYPE_GRAPHICS,

    /// Reserved for future use.
    COMMAND_QUEUE_TYPE_SPARSE_BINDING = 0x10,

    COMMAND_QUEUE_TYPE_MAX_BIT        = COMMAND_QUEUE_TYPE_GRAPHICS
}

/// Queue priority
enum QUEUE_PRIORITY : ubyte
{
    QUEUE_PRIORITY_UNKNOWN = 0,

    /// Vulkan backend:     VK_QUEUE_GLOBAL_PRIORITY_LOW_EXT
    /// Direct3D12 backend: D3D12_COMMAND_QUEUE_PRIORITY_NORMAL
    QUEUE_PRIORITY_LOW,

    /// Default queue priority.
    /// Vulkan backend:     VK_QUEUE_GLOBAL_PRIORITY_MEDIUM_EXT
    /// Direct3D12 backend: D3D12_COMMAND_QUEUE_PRIORITY_NORMAL
    QUEUE_PRIORITY_MEDIUM,

    /// Vulkan backend:     VK_QUEUE_GLOBAL_PRIORITY_HIGH_EXT
    /// Direct3D12 backend: D3D12_COMMAND_QUEUE_PRIORITY_HIGH
    QUEUE_PRIORITY_HIGH,

    /// Additional system privileges required to use this priority, read documentation for specific platform.
    /// Vulkan backend:     VK_QUEUE_GLOBAL_PRIORITY_REALTIME_EXT
    /// Direct3D12 backend: D3D12_COMMAND_QUEUE_PRIORITY_GLOBAL_REALTIME
    QUEUE_PRIORITY_REALTIME,

    QUEUE_PRIORITY_LAST = QUEUE_PRIORITY_REALTIME
}

/// Device memory properties
struct AdapterMemoryInfo
{
    /// The amount of local video memory that is inaccessible by CPU, in bytes.

    /// \note Device-local memory is where USAGE_DEFAULT and USAGE_IMMUTABLE resources
    ///       are typically allocated.
    ///
    ///       On some devices it may not be possible to query the memory size,
    ///       in which case all memory sizes will be zero.
    ulong  LocalMemory = 0;


    /// The amount of host-visible memory that can be accessed by CPU and is visible by GPU, in bytes.

    /// \note Host-visible memory is where USAGE_DYNAMIC and USAGE_STAGING resources
    ///       are typically allocated.
    ulong  HostVisibileMemory = 0;


    /// The amount of unified memory that can be directly accessed by both CPU and GPU, in bytes.

    /// \note Unified memory is where USAGE_UNIFIED resources are typically allocated, but
    ///       resourecs with other usages may be allocated as well if there is no corresponding
    ///       memory type.
    ulong  UnifiedMemory = 0;

    /// Supported access types for the unified memory.
    CPU_ACCESS_FLAGS UnifiedMemoryCPUAccess = CPU_ACCESS_FLAGS.CPU_ACCESS_NONE;

    /// Indicates if device supports color and depth attachments in on-chip memory.
    /// If supported, it will be combination of the following flags: BIND_RENDER_TARGET, BIND_DEPTH_STENCIL, BIND_INPUT_ATTACHMENT.
    BIND_FLAGS MemorylessTextureBindFlags = BIND_FLAGS.BIND_NONE;
}

/// Command queue properties
struct CommandQueueInfo
{
    /// Indicates which type of commands are supported by this queue, see Diligent::COMMAND_QUEUE_TYPE.
    COMMAND_QUEUE_TYPE QueueType = COMMAND_QUEUE_TYPE.COMMAND_QUEUE_TYPE_UNKNOWN;

    /// The maximum number of immediate contexts that may be created for this queue.
    uint             MaxDeviceContexts = 0;

    /// Defines required texture offset and size alignment for copy operations
    /// in transfer queues.
    
    /// \remarks An application should check this member before performing copy operations
    ///          in transfer queues.
    ///          Graphics and compute queues don't have alignment requirements (e.g
    ///          TextureCopyGranularity is always {1,1,1}).
    uint[3] TextureCopyGranularity = [];
}

/// Graphics adapter properties
struct GraphicsAdapterInfo
{
    /// A string that contains the adapter description.
    char[128] Description = [];

    /// Adapter type, see Diligent::ADAPTER_TYPE.
    ADAPTER_TYPE   Type = ADAPTER_TYPE.ADAPTER_TYPE_UNKNOWN;

    /// Adapter vendor, see Diligent::ADAPTER_VENDOR.
    ADAPTER_VENDOR Vendor = ADAPTER_VENDOR.ADAPTER_VENDOR_UNKNOWN;

    /// The PCI ID of the hardware vendor (if available).
    uint VendorId = 0;

    /// The PCI ID of the hardware device (if available).
    uint DeviceId = 0;

    /// Number of video outputs this adapter has (if available).
    uint NumOutputs = 0;

    /// Device memory information, see Diligent::AdapterMemoryInfo.
    AdapterMemoryInfo Memory;

    /// Ray tracing properties, see Diligent::RayTracingProperties.
    RayTracingProperties RayTracing;

    /// Wave operation properties, see Diligent::WaveOpProperties.
    WaveOpProperties WaveOp;

    /// Buffer properties, see Diligent::BufferProperties.
    BufferProperties Buffer;

    /// Texture properties, see Diligent::TextureProperties.
    TextureProperties Texture;

    /// Sampler properties, see Diligent::SamplerProperties.
    SamplerProperties Sampler;

    /// Mesh shader properties, see Diligent::MeshShaderProperties.
    MeshShaderProperties MeshShader;

    /// Compute shader properties, see Diligent::ComputeShaderProperties.
    ComputeShaderProperties ComputeShader;

    /// Supported device features, see Diligent::DeviceFeatures.

    /// \note The feature state indicates:
    ///       - Disabled - the feature is not supported by device.
    ///       - Enabled  - the feature is always enabled.
    ///       - Optional - the feature is supported and can be enabled or disabled.
    DeviceFeatures Features;

    /// An array of NumQueues command queues supported by this device. See Diligent::CommandQueueInfo.
    CommandQueueInfo[DILIGENT_MAX_ADAPTER_QUEUES] Queues = {};

    /// The number of queues in Queues array.
    uint NumQueues = 0;
}

/// Immediate device context create info
struct ImmediateContextCreateInfo
{
    /// Context name.
    const(char)* Name = null;

    /// Queue index in GraphicsAdapterInfo::Queues.

    /// \remarks An immediate device context creates a software command queue for the
    ///          hardware queue with id QueueId. The total number of contexts created for
    ///          this queue must not exceed the value of MaxDeviceContexts member of CommandQueueInfo
    ///          for this queue.
    ubyte QueueId = DEFAULT_QUEUE_ID;

    /// Priority of the software queue created by the context, see Diligent::QUEUE_PRIORITY.

    /// Direct3D12 backend: each context may use a unique queue priority.
    /// Vulkan backend:     all contexts with the same QueueId must use the same priority.
    /// Other backends:     queue priority is ignored.
    QUEUE_PRIORITY Priority = QUEUE_PRIORITY.QUEUE_PRIORITY_MEDIUM;
}

/// Engine creation information
struct EngineCreateInfo
{
    /// Engine API version number.
    int EngineAPIVersion = DILIGENT_API_VERSION;

    /// Id of the hardware adapter the engine should use.
    /// Call IEngineFactory::EnumerateAdapters() to get the list of available adapters.
    uint AdapterId = DEFAULT_ADAPTER_ID;

    /// Minimum required graphics API version (feature level for Direct3D).
    Version GraphicsAPIVersion = {};

    /// A pointer to the array of NumImmediateContexts structs decribing immediate
    /// device contexts to create. See Diligent::ImmediateContextCreateInfo.

    /// Every immediate device contexts encompases a command queue of a specific type.
    /// It may record commands directly or execute command lists recorded by deferred contexts.
    ///
    /// If not specified, single graphics context will be created.
    ///
    /// Recomended configuration:
    ///   * Modern discrete GPU:      1 graphics, 1 compute, 1 transfer context.
    ///   * Integrated or mobile GPU: 1..2 graphics contexts.
    const ImmediateContextCreateInfo* pImmediateContextInfo = null;

    /// The number of immediate contexts in pImmediateContextInfo array.

    /// \warning  If an application uses more than one immediate context,
    ///           it must manually call IDeviceContext::FinishFrame for
    ///           additional contexts to let the engine release stale resources.
    uint NumImmediateContexts = 0;

    /// The number of deferred contexts to create when initializing the engine. If non-zero number 
    /// is given, pointers to the contexts are written to ppContexts array by the engine factory 
    /// functions (IEngineFactoryD3D11::CreateDeviceAndContextsD3D11,
    /// IEngineFactoryD3D12::CreateDeviceAndContextsD3D12, and IEngineFactoryVk::CreateDeviceAndContextsVk)
    /// starting at position max(1, NumImmediateContexts).
    ///
    /// \warning  An application must manually call IDeviceContext::FinishFrame for
    ///           deferred contexts to let the engine release stale resources.
    uint NumDeferredContexts = 0;

    /// Requested device features.

    /// \remarks    If a feature is requested to be enabled, but is not supported
    ///             by the device/driver/platform, the engine will fail to initialize.
    ///
    ///             If a feature is requested to be optional, the engine will attempt to enable the feature.
    ///             If the feature is not supported by the device/driver/platform,
    ///             the engine will successfully be initialized, but the feature will be disabled.
    ///             The actual feature state can be queried from DeviceCaps structure.
    ///
    ///             Applications can query available device features for each graphics adpater with
    ///             IEngineFactory::EnumerateAdapters().
    DeviceFeatures Features;

    /// Enable backend-specific validation (e.g. use Direct3D11 debug device, enable Direct3D12
    /// debug layer, enable Vulkan validation layers, create debug OpenGL context, etc.).
    /// The validation is enabled by default in Debug/Development builds and disabled
    /// in release builds.
    bool EnableValidation = false;

    /// Validation options, see Diligent::VALIDATION_FLAGS.
    VALIDATION_FLAGS ValidationFlags = VALIDATION_FLAGS.VALIDATION_FLAG_NONE;

    /// Pointer to the raw memory allocator that will be used for all memory allocation/deallocation
    /// operations in the engine
    private import bindbc.diligent.primitives.memoryallocator;
    IMemoryAllocator* pRawMemAllocator = null;

    /// Pointer to the user-specified debug message callback function
    DebugMessageCallbackType DebugMessageCallback = null;
}

/// Attributes of the OpenGL-based engine implementation
struct EngineGLCreateInfo 
{
    EngineCreateInfo _EngineCreateInfo;

    /// Native window wrapper
    NativeWindow Window;
}


/// Direct3D11-specific validation options.
enum D3D11_VALIDATION_FLAGS : uint
{
    /// Direct3D11-specific validation is disabled.
    D3D11_VALIDATION_FLAG_NONE                                = 0x00,

    /// Verify that all committed cotext resources are relevant,
    /// i.e. they are consistent with the committed resource cache.
    /// This is very expensive and should only be used for engine debugging.
    /// This option is enabled in validation level 2 (see Diligent::VALIDATION_LEVEL).
    ///
    /// \remarks  This flag only has effect in Debug/Development builds.
    ///           This type of validation is never performed in Release builds.
    D3D11_VALIDATION_FLAG_VERIFY_COMMITTED_RESOURCE_RELEVANCE = 0x01
}

/// Attributes specific to D3D11 engine
struct EngineD3D11CreateInfo
{
    EngineCreateInfo _EngineCreateInfo;

    /// Direct3D11-specific validation options, see Diligent::D3D11_VALIDATION_FLAGS.
    D3D11_VALIDATION_FLAGS D3D11ValidationFlags = D3D11_VALIDATION_FLAGS.D3D11_VALIDATION_FLAG_NONE;

}

/// Direct3D12-specific validation flags.
enum D3D12_VALIDATION_FLAGS : uint
{
    /// Direct3D12-specific validation is disabled.
    D3D12_VALIDATION_FLAG_NONE                              = 0x00,

    /// Whether to break execution when D3D12 debug layer detects an error.
    /// This flag only has effect if validation is enabled (EngineCreateInfo.EnableValidation is true).
    /// This option is disabled by default in all validation levels. 
    D3D12_VALIDATION_FLAG_BREAK_ON_ERROR                    = 0x01,

    /// Whether to break execution when D3D12 debug layer detects a memory corruption.
    /// This flag only has effect if validation is enabled (EngineCreateInfo.EnableValidation is true).
    /// This option is enabled by default when validation is enabled. 
    D3D12_VALIDATION_FLAG_BREAK_ON_CORRUPTION               = 0x02,

    /// Enable validation on the GPU timeline.
    /// See https://docs.microsoft.com/en-us/windows/win32/direct3d12/using-d3d12-debug-layer-gpu-based-validation
    /// This flag only has effect if validation is enabled (EngineCreateInfo.EnableValidation is true).
    /// This option is enabled in validation level 2 (see Diligent::VALIDATION_LEVEL). 
    ///
    /// \note Enabling this option may slow things down a lot.
    D3D12_VALIDATION_FLAG_ENABLE_GPU_BASED_VALIDATION       = 0x04
}

/// Attributes specific to D3D12 engine
struct EngineD3D12CreateInfo
{
    EngineCreateInfo _EngineCreateInfo;

    /// Name of the D3D12 DLL to load. Ignored on UWP.
    const(char)* D3D12DllName = "d3d12.dll";
    /// Direct3D12-specific validation options, see Diligent::D3D12_VALIDATION_FLAGS.
    D3D12_VALIDATION_FLAGS D3D12ValidationFlags = D3D12_VALIDATION_FLAGS.D3D12_VALIDATION_FLAG_BREAK_ON_CORRUPTION;

    /// Size of the CPU descriptor heap allocations for different heap types.
    uint[4] CPUDescriptorHeapAllocationSize;

    /// The size of the GPU descriptor heap region designated to static/mutable
    /// shader resource variables.
    /// Every Shader Resource Binding object allocates one descriptor
    /// per any static/mutable shader resource variable (every array 
    /// element counts) when the object is created. All required descriptors
    /// are allocated in one continuous chunk.
    /// GPUDescriptorHeapSize defines the total number of all descriptors
    /// that can be allocated across all SRB objects.
    /// Note that due to heap fragmentation, releaseing two chunks of sizes
    /// N and M does not necessarily make the chunk of size N+M available.
    uint[2] GPUDescriptorHeapSize;

    /// The size of the GPU descriptor heap region designated to dynamic
    /// shader resource variables.
    /// Every Shader Resource Binding object allocates one descriptor
    /// per any dynamic shader resource variable (every array element counts)
    /// every time the object is committed via IDeviceContext::CommitShaderResources.
    /// All used dynamic descriptors are discarded at the end of the frame
    /// and recycled when they are no longer used by the GPU.
    /// GPUDescriptorHeapDynamicSize defines the total number of descriptors
    /// that can be used for dynamic variables across all SRBs and all frames
    /// currently in flight.
    /// Note that in Direct3D12, the size of sampler descriptor heap is limited
    /// by 2048. Since Diligent Engine allocates single heap for all variable types,
    /// GPUDescriptorHeapSize[1] + GPUDescriptorHeapDynamicSize[1] must not
    /// exceed 2048.
    uint[2] GPUDescriptorHeapDynamicSize;

    /// The size of the chunk that dynamic descriptor allocations manager
    /// requests from the main GPU descriptor heap.
    /// The total number of dynamic descriptors available across all frames in flight is 
    /// defined by GPUDescriptorHeapDynamicSize. Every device context allocates dynamic
    /// descriptors in two stages: it first requests a chunk from the global heap, and the 
    /// performs linear suballocations from this chunk in a lock-free manner. The size of 
    /// this chunk is defined by DynamicDescriptorAllocationChunkSize, thus there will be total
    /// GPUDescriptorHeapDynamicSize/DynamicDescriptorAllocationChunkSize chunks in
    /// the heap of each type.
    uint[2] DynamicDescriptorAllocationChunkSize;

    /// A device context uses dynamic heap when it needs to allocate temporary
    /// CPU-accessible memory to update a resource via IDeviceContext::UpdateBuffer() or
    /// IDeviceContext::UpdateTexture(), or to map dynamic resources.
    /// Device contexts first request a chunk of memory from global dynamic
    /// resource manager and then suballocate from this chunk in a lock-free
    /// fashion. DynamicHeapPageSize defines the size of this chunk.
    uint DynamicHeapPageSize = 1 << 20;

    /// Number of dynamic heap pages that will be reserved by the
    /// global dynamic heap manager to avoid page creation at run time.
    uint NumDynamicHeapPagesToReserve = 1;

    /// Query pool size for each query type.
    uint[QUERY_TYPE.QUERY_TYPE_NUM_TYPES] QueryPoolSizes;

    /// Path to DirectX Shader Compiler, which is required to use Shader Model 6.0+ features.
    /// By default, the engine will search for "dxcompiler.dll".
    const(char)* pDxCompilerPath = null;
}

/// Descriptor pool size
struct VulkanDescriptorPoolSize
{
    uint MaxDescriptorSets = 0;
    uint NumSeparateSamplerDescriptors = 0;
    uint NumCombinedSamplerDescriptors = 0;
    uint NumSampledImageDescriptors = 0;
    uint NumStorageImageDescriptors = 0;
    uint NumUniformBufferDescriptors = 0;
    uint NumStorageBufferDescriptors = 0;
    uint NumUniformTexelBufferDescriptors = 0;
    uint NumStorageTexelBufferDescriptors = 0;
    uint NumInputAttachmentDescriptors = 0;
    uint NumAccelStructDescriptors = 0;
}

/// Attributes specific to Vulkan engine
struct EngineVkCreateInfo
{
    EngineCreateInfo _EngineCreateInfo;

    /// The number of Vulkan instance extensions in ppInstanceExtensionNames array.
    uint             InstanceExtensionCount = 0;

    /// A list of InstanceExtensionCount Vulkan instance extensions to enable.
    const char* ppInstanceExtensionNames = null;

    /// Number of Vulkan device extensions in ppDeviceExtensionNames array.
    uint             DeviceExtensionCount = 0;

    /// List of Vulkan device extensions to enable.
    const char* ppDeviceExtensionNames = null;

    /// Pointer to Vulkan device extension features.
    /// Will be added to VkDeviceCreateInfo::pNext.
    void*              pDeviceExtensionFeatures = null;

    /// Allocator used as pAllocator parameter in calls to Vulkan Create* functions
    void*              pVkAllocator = null;

    /// Size of the main descriptor pool that is used to allocate descriptor sets
    /// for static and mutable variables. If allocation from the current pool fails,
    /// the engine creates another one.
    VulkanDescriptorPoolSize MainDescriptorPoolSize;

    /// Size of the dynamic descriptor pool that is used to allocate descriptor sets
    /// for dynamic variables. Every device context has its own dynamic descriptor set allocator.
    /// The allocator requests pools from global dynamic descriptor pool manager, and then 
    /// performs lock-free suballocations from the pool.

    VulkanDescriptorPoolSize DynamicDescriptorPoolSize;

    /// Allocation granularity for device-local memory
    uint DeviceLocalMemoryPageSize = 16 << 20;

    /// Allocation granularity for host-visible memory
    uint HostVisibleMemoryPageSize = 16 << 20;

    /// Amount of device-local memory reserved by the engine. 
    /// The engine does not pre-allocate the memory, but rather keeps free
    /// pages when resources are released
    uint DeviceLocalMemoryReserveSize = 256 << 20;

    /// Amount of host-visible memory reserved by the engine.
    /// The engine does not pre-allocate the memory, but rather keeps free
    /// pages when resources are released
    uint HostVisibleMemoryReserveSize = 256 << 20;

    /// Page size of the upload heap that is allocated by immediate/deferred
    /// contexts from the global memory manager to perform lock-free dynamic
    /// suballocations.
    /// Upload heap is used to update resources with IDeviceContext::UpdateBuffer()
    /// and IDeviceContext::UpdateTexture().
    uint UploadHeapPageSize = 1 << 20;

    /// Size of the dynamic heap (the buffer that is used to suballocate 
    /// memory for dynamic resources) shared by all contexts.
    uint DynamicHeapSize = 8 << 20;

    /// Size of the memory chunk suballocated by immediate/deferred context from
    /// the global dynamic heap to perform lock-free dynamic suballocations
    uint DynamicHeapPageSize = 256 << 10;

    /// Query pool size for each query type.
    uint[QUERY_TYPE.QUERY_TYPE_NUM_TYPES] QueryPoolSizes;

    /// Path to DirectX Shader Compiler, which is required to use Shader Model 6.0+
    /// features when compiling shaders from HLSL.
    const(char)* pDxCompilerPath = null;

}

/// Attributes of the Metal-based engine implementation
struct EngineMtlCreateInfo
{
    EngineCreateInfo _EngineCreateInfo;

    /// A device context uses dynamic heap when it needs to allocate temporary
    /// CPU-accessible memory to update a resource via IDeviceContext::UpdateBuffer() or
    /// IDeviceContext::UpdateTexture(), or to map dynamic resources.
    /// Device contexts first request a chunk of memory from global dynamic
    /// resource manager and then suballocate from this chunk in a lock-free
    /// fashion. DynamicHeapPageSize defines the size of this chunk.
    uint DynamicHeapPageSize = 4 << 20;


    /// Indicates if device contexts should automatically manage autorelease pools.

    /// Metal API creates a lot of autoreleased objects. By default, the engine
    /// will catch all these objects by pushing autorelease pools where necessary.
    /// When UseAutoreleasePoolsInContexts is set to false, the engine will not use
    /// autorelease pools in device contexts and the application will be responsible
    /// for ensuring that all context commands are issued from within an autorelease
    /// pool to avoid memory leaks.
    ///
    /// \note Autorelease pool is pushed by the first command of the device context
    ///       that needs it and popped by IDeviceContext::FinishFrame().
    ///       The method must always be called from the same thread that
    ///       issued the context commands.
    ///
    ///       Creating device objects will not leak memory even when
    ///       UseAutoreleasePoolsInContexts is set to false.
    bool UseAutoreleasePoolsInContexts = true;

    /// Query pool size for each query type.
    uint[QUERY_TYPE.QUERY_TYPE_NUM_TYPES] QueryPoolSizes;
}

/// Box
struct Box
{
    uint MinX = 0; ///< Minimal X coordinate. Default value is 0
    uint MaxX = 0; ///< Maximal X coordinate. Default value is 0
    uint MinY = 0; ///< Minimal Y coordinate. Default value is 0
    uint MaxY = 0; ///< Maximal Y coordinate. Default value is 0
    uint MinZ = 0; ///< Minimal Z coordinate. Default value is 0
    uint MaxZ = 1; ///< Maximal Z coordinate. Default value is 1
}

/// Describes texture format component type
enum COMPONENT_TYPE :ubyte
{
    /// Undefined component type
    COMPONENT_TYPE_UNDEFINED,

    /// Floating point component type
    COMPONENT_TYPE_FLOAT,

    /// Signed-normalized-integer component type
    COMPONENT_TYPE_SNORM,

    /// Unsigned-normalized-integer component type
    COMPONENT_TYPE_UNORM,

    /// Unsigned-normalized-integer sRGB component type
    COMPONENT_TYPE_UNORM_SRGB,

    /// Signed-integer component type
    COMPONENT_TYPE_SINT,

    /// Unsigned-integer component type
    COMPONENT_TYPE_UINT,

    /// Depth component type
    COMPONENT_TYPE_DEPTH,

    /// Depth-stencil component type
    COMPONENT_TYPE_DEPTH_STENCIL,

    /// Compound component type (example texture formats: TEX_FORMAT_R11G11B10_FLOAT or TEX_FORMAT_RGB9E5_SHAREDEXP)
    COMPONENT_TYPE_COMPOUND,

    /// Compressed component type
    COMPONENT_TYPE_COMPRESSED,
}

/// Describes invariant texture format attributes. These attributes are 
/// intrinsic to the texture format itself and do not depend on the 
/// format support.
struct TextureFormatAttribs
{
    /// Literal texture format name (for instance, for TEX_FORMAT_RGBA8_UNORM format, this
    /// will be "TEX_FORMAT_RGBA8_UNORM")
    const(char)* Name = "TEX_FORMAT_UNKNOWN";

    /// Texture format, see Diligent::TEXTURE_FORMAT for a list of supported texture formats
    TEXTURE_FORMAT Format = TEXTURE_FORMAT.TEX_FORMAT_UNKNOWN;

    /// Size of one component in bytes (for instance, for TEX_FORMAT_RGBA8_UNORM format, this will be 1)
    /// For compressed formats, this is the block size in bytes (for TEX_FORMAT_BC1_UNORM format, this will be 8)
    ubyte ComponentSize = 0;

    /// Number of components
    ubyte NumComponents = 0;

    /// Component type, see Diligent::COMPONENT_TYPE for details.
    COMPONENT_TYPE ComponentType = COMPONENT_TYPE.COMPONENT_TYPE_UNDEFINED;

    /// Bool flag indicating if the format is a typeless format
    bool IsTypeless = false;

    /// For block-compressed formats, compression block width
    ubyte BlockWidth = 0;

    /// For block-compressed formats, compression block height
    ubyte BlockHeight = 0;
}

/// Basic texture format description

/// This structure is returned by IRenderDevice::GetTextureFormatInfo()
struct TextureFormatInfo
{
    TextureFormatAttribs _TextureFormatAttribs;

    /// Indicates if the format is supported by the device
    bool Supported = false;

    // Explicitly pad the structure to 8-byte boundary
    bool[7] Padding;
}


/// Describes device support of a particular resource dimension for a given texture format.
enum RESOURCE_DIMENSION_SUPPORT : uint
{
    /// The device does not support any resources for this format.
    RESOURCE_DIMENSION_SUPPORT_NONE           = 0,

    /// Indicates if the device supports buffer resources for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_BUFFER         = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_BUFFER,

    /// Indicates if the device supports 1D textures for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_TEX_1D         = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_TEX_1D,

    /// Indicates if the device supports 1D texture arrays for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_TEX_1D_ARRAY   = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_TEX_1D_ARRAY,

    /// Indicates if the device supports 2D textures for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_TEX_2D         = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_TEX_2D,

    /// Indicates if the device supports 2D texture arrays for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_TEX_2D_ARRAY   = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_TEX_2D_ARRAY,

    /// Indicates if the device supports 3D textures for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_TEX_3D         = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_TEX_3D,

    /// Indicates if the device supports cube textures for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_TEX_CUBE       = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_TEX_CUBE,

    /// Indicates if the device supports cube texture arrays for a particular texture format.
    RESOURCE_DIMENSION_SUPPORT_TEX_CUBE_ARRAY = 1 << RESOURCE_DIMENSION.RESOURCE_DIM_TEX_CUBE_ARRAY
}

/// Extended texture format information.

/// This structure is returned by IRenderDevice::GetTextureFormatInfoExt()
struct TextureFormatInfoExt
{
    TextureFormatInfo _TextureFormatInfo;
    /// Allowed bind flags for this format.
    BIND_FLAGS BindFlags = BIND_FLAGS.BIND_NONE;

    /// A bitmask specifying all the supported resource dimensions for this texture format,
    /// see Diligent::RESOURCE_DIMENSION_SUPPORT.

    /// For every supported resource dimension in RESOURCE_DIMENSION enum,
    /// the corresponding bit in the mask will be set to 1.
    /// For example, support for Texture2D resource dimension can be checked as follows:
    ///
    ///     (Dimensions & RESOURCE_DIMENSION_SUPPORT_TEX_2D) != 0
    ///
    RESOURCE_DIMENSION_SUPPORT Dimensions = RESOURCE_DIMENSION_SUPPORT.RESOURCE_DIMENSION_SUPPORT_NONE;

    /// A bitmask specifying all the supported sample counts for this texture format.
    /// If the format supports n samples, then (SampleCounts & n) != 0
    uint SampleCounts = 0;

    /// Indicates if the format can be filtered in the shader.
    bool Filterable = false;
}

/// Pipeline stage flags.

/// These flags mirror [VkPipelineStageFlagBits](https://www.khronos.org/registry/vulkan/specs/1.1-extensions/html/vkspec.html#VkPipelineStageFlagBits)
/// enum and only have effect in Vulkan backend.
enum PIPELINE_STAGE_FLAGS : uint
{
    /// Undefined stage
    PIPELINE_STAGE_FLAG_UNDEFINED                    = 0x00000000,

    /// The top of the pipeline.
    PIPELINE_STAGE_FLAG_TOP_OF_PIPE                  = 0x00000001,

    /// The stage of the pipeline where Draw/DispatchIndirect data structures are consumed.
    PIPELINE_STAGE_FLAG_DRAW_INDIRECT                = 0x00000002,

    /// The stage of the pipeline where vertex and index buffers are consumed.
    PIPELINE_STAGE_FLAG_VERTEX_INPUT                 = 0x00000004,

    /// Vertex shader stage.
    PIPELINE_STAGE_FLAG_VERTEX_SHADER                = 0x00000008,
    
    /// Hull shader stage.
    PIPELINE_STAGE_FLAG_HULL_SHADER                  = 0x00000010,
    
    /// Domain shader stage.
    PIPELINE_STAGE_FLAG_DOMAIN_SHADER                = 0x00000020,
    
    /// Geometry shader stage.
    PIPELINE_STAGE_FLAG_GEOMETRY_SHADER              = 0x00000040,
    
    /// Pixel shader stage.
    PIPELINE_STAGE_FLAG_PIXEL_SHADER                 = 0x00000080,
    
    /// The stage of the pipeline where early fragment tests (depth and
    /// stencil tests before fragment shading) are performed. This stage
    /// also includes subpass load operations for framebuffer attachments
    /// with a depth/stencil format.
    PIPELINE_STAGE_FLAG_EARLY_FRAGMENT_TESTS         = 0x00000100,
    
    /// The stage of the pipeline where late fragment tests (depth and 
    /// stencil tests after fragment shading) are performed. This stage
    /// also includes subpass store operations for framebuffer attachments
    /// with a depth/stencil format.
    PIPELINE_STAGE_FLAG_LATE_FRAGMENT_TESTS          = 0x00000200,
    
    /// The stage of the pipeline after blending where the final color values
    /// are output from the pipeline. This stage also includes subpass load
    /// and store operations and multisample resolve operations for framebuffer
    /// attachments with a color or depth/stencil format.
    PIPELINE_STAGE_FLAG_RENDER_TARGET                = 0x00000400,
    
    /// Compute shader stage.
    PIPELINE_STAGE_FLAG_COMPUTE_SHADER               = 0x00000800,
    
    /// The stage where all copy and outside-of-renderpass
    /// resolve and clear operations happen.
    PIPELINE_STAGE_FLAG_TRANSFER                     = 0x00001000,
    
    /// The bottom of the pipeline.
    PIPELINE_STAGE_FLAG_BOTTOM_OF_PIPE               = 0x00002000,
    
    /// A pseudo-stage indicating execution on the host of reads/writes
    /// of device memory. This stage is not invoked by any commands recorded
    /// in a command buffer.
    PIPELINE_STAGE_FLAG_HOST                         = 0x00004000,
    
    /// The stage of the pipeline where the predicate of conditional rendering is consumed.
    PIPELINE_STAGE_FLAG_CONDITIONAL_RENDERING        = 0x00040000,

    /// The stage of the pipeline where the shading rate texture is
    /// read to determine the shading rate for portions of a rasterized primitive.
    PIPELINE_STAGE_FLAG_SHADING_RATE_TEXTURE         = 0x00400000,
    
    /// Ray tracing shader.
    PIPELINE_STAGE_FLAG_RAY_TRACING_SHADER           = 0x00200000,
    
    /// Acceleration structure build shader.
    PIPELINE_STAGE_FLAG_ACCELERATION_STRUCTURE_BUILD = 0x02000000,
    
    /// Task shader stage.
    PIPELINE_STAGE_FLAG_TASK_SHADER                  = 0x00080000,
    
    /// Mesh shader stage.
    PIPELINE_STAGE_FLAG_MESH_SHADER                  = 0x00100000,
    
    /// 
    PIPELINE_STAGE_FLAG_FRAGMENT_DENSITY_PROCESS     = 0x00800000,
    
    /// Default pipeline stage that is determined by the resource state.
    /// For example, RESOURCE_STATE_RENDER_TARGET corresponds to
    /// PIPELINE_STAGE_FLAG_RENDER_TARGET pipeline stage.
    PIPELINE_STAGE_FLAG_DEFAULT                      = 0x80000000
}

/// Access flag.

/// The flags mirror [VkAccessFlags](https://www.khronos.org/registry/vulkan/specs/1.1-extensions/html/vkspec.html#VkAccessFlags) enum
/// and only have effect in Vulkan backend.
enum ACCESS_FLAGS : uint
{
    /// No access
    ACCESS_FLAG_NONE                         = 0x00000000,

    /// Read access to indirect command data read as part of an indirect
    /// drawing or dispatch command.
    ACCESS_FLAG_INDIRECT_COMMAND_READ        = 0x00000001,

    /// Read access to an index buffer as part of an indexed drawing command
    ACCESS_FLAG_INDEX_READ                   = 0x00000002,

    /// Read access to a vertex buffer as part of a drawing command
    ACCESS_FLAG_VERTEX_READ                  = 0x00000004,

    /// Read access to a uniform buffer
    ACCESS_FLAG_UNIFORM_READ                 = 0x00000008,

    /// Read access to an input attachment within a render pass during fragment shading
    ACCESS_FLAG_INPUT_ATTACHMENT_READ        = 0x00000010,

    /// Read access from a shader resource, formatted buffer, UAV
    ACCESS_FLAG_SHADER_READ                  = 0x00000020,

    /// Write access to a UAV
    ACCESS_FLAG_SHADER_WRITE                 = 0x00000040,

    /// Read access to a color render target, such as via blending,
    /// logic operations, or via certain subpass load operations.
    ACCESS_FLAG_RENDER_TARGET_READ           = 0x00000080,
    
    /// Write access to a color render target, resolve, or depth/stencil resolve
    /// attachment during a render pass or via certain subpass load and store operations.
    ACCESS_FLAG_RENDER_TARGET_WRITE          = 0x00000100,

    /// Read access to a depth/stencil buffer, via depth or stencil operations
    /// or via certain subpass load operations
    ACCESS_FLAG_DEPTH_STENCIL_READ           = 0x00000200,

    /// Write access to a depth/stencil buffer, via depth or stencil operations
    /// or via certain subpass load and store operations
    ACCESS_FLAG_DEPTH_STENCIL_WRITE          = 0x00000400,

    /// Read access to an texture or buffer in a copy operation.
    ACCESS_FLAG_COPY_SRC                     = 0x00000800,

    /// Write access to an texture or buffer in a copy operation.
    ACCESS_FLAG_COPY_DST                     = 0x00001000,

    /// Read access by a host operation. Accesses of this type are
    /// not performed through a resource, but directly on memory.
    ACCESS_FLAG_HOST_READ                    = 0x00002000,

    /// Write access by a host operation. Accesses of this type are
    /// not performed through a resource, but directly on memory.
    ACCESS_FLAG_HOST_WRITE                   = 0x00004000,

    /// All read accesses. It is always valid in any access mask,
    /// and is treated as equivalent to setting all READ access flags
    /// that are valid where it is used.
    ACCESS_FLAG_MEMORY_READ                  = 0x00008000,

    /// All write accesses. It is always valid in any access mask,
    /// and is treated as equivalent to setting all WRITE access
    // flags that are valid where it is used.
    ACCESS_FLAG_MEMORY_WRITE                 = 0x00010000,

    /// Read access to a predicate as part of conditional rendering.
    ACCESS_FLAG_CONDITIONAL_RENDERING_READ   = 0x00100000,

    /// Read access to a shading rate texture as part of a drawing command.
    ACCESS_FLAG_SHADING_RATE_TEXTURE_READ    = 0x00800000,

    /// Read access to an acceleration structure as part of a trace or build command.
    ACCESS_FLAG_ACCELERATION_STRUCTURE_READ  = 0x00200000,

    /// Write access to an acceleration structure or acceleration structure
    /// scratch buffer as part of a build command.
    ACCESS_FLAG_ACCELERATION_STRUCTURE_WRITE = 0x00400000,

    /// Read access to a fragment density map attachment during
    /// dynamic fragment density map operations.
    ACCESS_FLAG_FRAGMENT_DENSITY_MAP_READ    = 0x01000000,

    /// Default access type that is determined by the resource state.
    /// For example, RESOURCE_STATE_RENDER_TARGET corresponds to
    /// ACCESS_FLAG_RENDER_TARGET_WRITE access type.
    ACCESS_FLAG_DEFAULT                      = 0x80000000
}

/// Resource usage state
enum RESOURCE_STATE : uint
{
    /// The resource state is not known to the engine and is managed by the application
    RESOURCE_STATE_UNKNOWN              = 0,

    /// The resource state is known to the engine, but is undefined. A resource is typically in an undefined state right after initialization.
    RESOURCE_STATE_UNDEFINED            = 1u << 0,

    /// The resource is accessed as a vertex buffer
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_VERTEX_BUFFER        = 1u << 1,

    /// The resource is accessed as a constant (uniform) buffer
    /// \remarks Supported contexts: graphics, compute.
    RESOURCE_STATE_CONSTANT_BUFFER      = 1u << 2,

    /// The resource is accessed as an index buffer
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_INDEX_BUFFER         = 1u << 3,

    /// The resource is accessed as a render target
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_RENDER_TARGET        = 1u << 4,

    /// The resource is used for unordered access
    /// \remarks Supported contexts: graphics, compute.
    RESOURCE_STATE_UNORDERED_ACCESS     = 1u << 5,

    /// The resource is used in a writable depth-stencil view or in clear operation
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_DEPTH_WRITE          = 1u << 6,

    /// The resource is used in a read-only depth-stencil view
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_DEPTH_READ           = 1u << 7,

    /// The resource is accessed from a shader
    /// \remarks Supported contexts: graphics, compute.
    RESOURCE_STATE_SHADER_RESOURCE      = 1u << 8,

    /// The resource is used as the destination for stream output
    RESOURCE_STATE_STREAM_OUT           = 1u << 9,

    /// The resource is used as an indirect draw/dispatch arguments buffer
    /// \remarks Supported contexts: graphics, compute.
    RESOURCE_STATE_INDIRECT_ARGUMENT    = 1u << 10,

    /// The resource is used as the destination in a copy operation
    /// \remarks Supported contexts: graphics, compute, transfer.
    RESOURCE_STATE_COPY_DEST            = 1u << 11,

    /// The resource is used as the source in a copy operation 
    /// \remarks Supported contexts: graphics, compute, transfer.
    RESOURCE_STATE_COPY_SOURCE          = 1u << 12,

    /// The resource is used as the destination in a resolve operation 
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_RESOLVE_DEST         = 1u << 13,

    /// The resource is used as the source in a resolve operation 
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_RESOLVE_SOURCE       = 1u << 14,

    /// The resource is used as an input attachment in a render pass subpass
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_INPUT_ATTACHMENT     = 1u << 15,

    /// The resource is used for present
    /// \remarks Supported contexts: graphics.
    RESOURCE_STATE_PRESENT              = 1u << 16,

    /// The resource is used as vertex/index/instance buffer in an AS building operation
    /// or as an acceleration structure source in an AS copy operation.
    /// \remarks Supported contexts: graphics, compute.
    RESOURCE_STATE_BUILD_AS_READ        = 1u << 17,

    /// The resource is used as the target for AS building or AS copy operations.
    /// \remarks Supported contexts: graphics, compute.
    RESOURCE_STATE_BUILD_AS_WRITE       = 1u << 18,

    /// The resource is used as a top-level AS shader resource in a trace rays operation.
    /// \remarks Supported contexts: graphics, compute.
    RESOURCE_STATE_RAY_TRACING          = 1u << 19,

    /// The resource state is used for read operations, but access to the resource may be slower compared to the specialized state.
    /// A transition to the COMMON state is always a pipeline stall and can often induce a cache flush and render target decompress operation.
    /// \remarks In D3D12 backend, a resource must be in COMMON state for transition between graphics/compute queue and copy queue.
    /// \remarks Supported contexts: graphics, compute, transfer.
    RESOURCE_STATE_COMMON               = 1u << 20,

    RESOURCE_STATE_MAX_BIT              = RESOURCE_STATE_COMMON,

    RESOURCE_STATE_GENERIC_READ         = RESOURCE_STATE_VERTEX_BUFFER     |
                                          RESOURCE_STATE_CONSTANT_BUFFER   |
                                          RESOURCE_STATE_INDEX_BUFFER      |
                                          RESOURCE_STATE_SHADER_RESOURCE   |
                                          RESOURCE_STATE_INDIRECT_ARGUMENT |
                                          RESOURCE_STATE_COPY_SOURCE
}

/// State transition barrier type
enum STATE_TRANSITION_TYPE : ubyte
{
    /// Perform state transition immediately.
    STATE_TRANSITION_TYPE_IMMEDIATE = 0,

    /// Begin split barrier. This mode only has effect in Direct3D12 backend, and corresponds to
    /// [D3D12_RESOURCE_BARRIER_FLAG_BEGIN_ONLY](https://docs.microsoft.com/en-us/windows/desktop/api/d3d12/ne-d3d12-d3d12_resource_barrier_flags)
    /// flag. See https://docs.microsoft.com/en-us/windows/desktop/direct3d12/using-resource-barriers-to-synchronize-resource-states-in-direct3d-12#split-barriers.
    /// In other backends, begin-split barriers are ignored.
    STATE_TRANSITION_TYPE_BEGIN,

    /// End split barrier. This mode only has effect in Direct3D12 backend, and corresponds to
    /// [D3D12_RESOURCE_BARRIER_FLAG_END_ONLY](https://docs.microsoft.com/en-us/windows/desktop/api/d3d12/ne-d3d12-d3d12_resource_barrier_flags)
    /// flag. See https://docs.microsoft.com/en-us/windows/desktop/direct3d12/using-resource-barriers-to-synchronize-resource-states-in-direct3d-12#split-barriers.
    /// In other backends, this mode is similar to STATE_TRANSITION_TYPE_IMMEDIATE.
    STATE_TRANSITION_TYPE_END
}
