/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Graphics/GraphicsEngine/interface/Shader.h
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

/// \file
/// Definition of the Diligent::IShader interface and related data structures

import bindbc.diligent.primitives.filestream;
import bindbc.diligent.graphics.deviceobject;

// {2989B45C-143D-4886-B89C-C3271C2DCC5D}
static const INTERFACE_ID IID_Shader =
    INTERFACE_ID(0x2989b45c, 0x143d, 0x4886, [0xb8, 0x9c, 0xc3, 0x27, 0x1c, 0x2d, 0xcc, 0x5d]);

alias ShaderVersion = Version;

/// Describes the shader source code language
enum SHADER_SOURCE_LANGUAGE : int
{
    /// Default language (GLSL for OpenGL/OpenGLES/Vulkan devices, HLSL for Direct3D11/Direct3D12 devices)
    SHADER_SOURCE_LANGUAGE_DEFAULT = 0,

    /// The source language is HLSL
    SHADER_SOURCE_LANGUAGE_HLSL,

    /// The source language is GLSL
    SHADER_SOURCE_LANGUAGE_GLSL,

    /// The source language is Metal shading language (MSL)
    SHADER_SOURCE_LANGUAGE_MSL,

    /// The source language is GLSL that should be compiled verbatim

    /// By default the engine prepends GLSL shader source code with platform-specific
    /// definitions. For instance it adds appropriate #version directive (e.g. '#version 430 core' or
    /// '#version 310 es') so that the same source will work on different versions of desktop OpenGL and OpenGLES.
    /// When SHADER_SOURCE_LANGUAGE_GLSL_VERBATIM is used, the source code will be compiled as is.
    /// Note that shader macros are ignored when compiling GLSL verbatim in OpenGL backend, and an application
    /// should add the macro definitions to the source code.
    SHADER_SOURCE_LANGUAGE_GLSL_VERBATIM
}

/// Describes the shader compiler that will be used to compile the shader source code
enum SHADER_COMPILER : int
{
    /// Default compiler for specific language and API that is selected as follows:
    ///     - Direct3D11:      legacy HLSL compiler (FXC)
    ///     - Direct3D12:      legacy HLSL compiler (FXC)
    ///     - OpenGL(ES) GLSL: native compiler
    ///     - OpenGL(ES) HLSL: HLSL2GLSL converter and native compiler
    ///     - Vulkan GLSL:     built-in glslang
    ///     - Vulkan HLSL:     built-in glslang (with limited support for Shader Model 6.x)
    ///     - Metal GLSL/HLSL: built-in glslang (HLSL with limited support for Shader Model 6.x)
    ///     - Metal MSL:       native compiler
    SHADER_COMPILER_DEFAULT = 0,

    /// Built-in glslang compiler for GLSL and HLSL.
    SHADER_COMPILER_GLSLANG,

    /// Modern HLSL compiler (DXC) for Direct3D12 and Vulkan with Shader Model 6.x support.
    SHADER_COMPILER_DXC,

    /// Legacy HLSL compiler (FXC) for Direct3D11 and Direct3D12 supporting shader models up to 5.1.
    SHADER_COMPILER_FXC,

    SHADER_COMPILER_LAST = SHADER_COMPILER_FXC
}


/// Describes the flags that can be passed over to IShaderSourceInputStreamFactory::CreateInputStream2() function.
enum CREATE_SHADER_SOURCE_INPUT_STREAM_FLAGS : int
{
    /// No flag.
    CREATE_SHADER_SOURCE_INPUT_STREAM_FLAG_NONE = 0x00,

    /// Do not output any messages if the file is not found or
    /// other errors occur.
    CREATE_SHADER_SOURCE_INPUT_STREAM_FLAG_SILENT = 0x01,
}

/// Shader description
struct ShaderDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// Shader type. See Diligent::SHADER_TYPE.
    SHADER_TYPE ShaderType = SHADER_TYPE.SHADER_TYPE_UNKNOWN;
}

// {3EA98781-082F-4413-8C30-B9BA6D82DBB7}
static const INTERFACE_ID IID_IShaderSourceInputStreamFactory =
    INTERFACE_ID(0x3ea98781, 0x82f, 0x4413, [0x8c, 0x30, 0xb9, 0xba, 0x6d, 0x82, 0xdb, 0xb7]);


/// Shader source stream factory interface
struct IShaderSourceInputStreamFactoryMethods
{
    void* CreateInputStream(IShaderSourceInputStreamFactory*,
                                           const(char)* Name,
                                           IFileStream** ppStream);

    void* CreateInputStream2(IShaderSourceInputStreamFactory*,
                                            const(char)*                            Name,
                                            CREATE_SHADER_SOURCE_INPUT_STREAM_FLAGS Flags,
                                            IFileStream**                           ppStream);
}

struct IShaderSourceInputStreamFactoryVtbl { IShaderSourceInputStreamFactoryMethods ShaderSourceInputStreamFactory; }
struct IShaderSourceInputStreamFactory { IShaderSourceInputStreamFactoryVtbl* pVtbl; }

//#    define IShaderSourceInputStreamFactory_CreateInputStream(This, ...)  CALL_IFACE_METHOD(ShaderSourceInputStreamFactory, CreateInputStream, This, __VA_ARGS__)
//#    define IShaderSourceInputStreamFactory_CreateInputStream2(This, ...) CALL_IFACE_METHOD(ShaderSourceInputStreamFactory, CreateInputStream2, This, __VA_ARGS__)
void* IShaderSourceInputStreamFactory_CreateInputStream(ShaderSourceInputStreamFactory* factory,
                                           const(char)* name,
                                           IFileStream** ppStream) {
    factory.pVtbl.CreateInputStream(factory, name, ppStream);
}

void* IShaderSourceInputStreamFactory_CreateInputStream2(IShaderSourceInputStreamFactory* factory,
                                            const(char)*                            name,
                                            CREATE_SHADER_SOURCE_INPUT_STREAM_FLAGS flags,
                                            IFileStream**                           ppStream) {
    factory.pVtbl.CreateInputStream(factory, name, flags, ppStream);
}


struct ShaderMacro
{
    const(char)* Name = null;
    const(char)* Definition = null;
}

/// Shader compilation flags
enum SHADER_COMPILE_FLAGS : uint
{
    /// No flags.
    SHADER_COMPILE_FLAG_NONE = 0x0,

    /// Enable unbounded resource arrays (e.g. Texture2D g_Texture[]).
    SHADER_COMPILE_FLAG_ENABLE_UNBOUNDED_ARRAYS = 0x01,

    SHADER_COMPILE_FLAG_LAST = SHADER_COMPILE_FLAG_ENABLE_UNBOUNDED_ARRAYS
}

/// Shader creation attributes
struct ShaderCreateInfo
{
    /// Source file path

    /// If source file path is provided, Source and ByteCode members must be null
    const(char)* FilePath = null;

    /// Pointer to the shader source input stream factory.

    /// The factory is used to load the shader source file if FilePath is not null.
    /// It is also used to create additional input streams for shader include files
    IShaderSourceInputStreamFactory* pShaderSourceStreamFactory = null;

    /// HLSL->GLSL conversion stream

    /// If HLSL->GLSL converter is used to convert HLSL shader source to
    /// GLSL, this member can provide pointer to the conversion stream. It is useful
    /// when the same file is used to create a number of different shaders. If
    /// ppConversionStream is null, the converter will parse the same file
    /// every time new shader is converted. If ppConversionStream is not null,
    /// the converter will write pointer to the conversion stream to *ppConversionStream
    /// the first time and will use it in all subsequent times.
    /// For all subsequent conversions, FilePath member must be the same, or
    /// new stream will be created and warning message will be displayed.
    IHLSL2GLSLConversionStream** ppConversionStream = null;;

    /// Shader source

    /// If shader source is provided, FilePath and ByteCode members must be null
    const(char)* Source = null;

    /// Compiled shader bytecode.

    /// If shader byte code is provided, FilePath and Source members must be null
    /// \note. This option is supported for D3D11, D3D12 and Vulkan backends.
    ///        For D3D11 and D3D12 backends, HLSL bytecode should be provided. Vulkan
    ///        backend expects SPIRV bytecode.
    ///        The bytecode must contain reflection information. If shaders were compiled
    ///        using fxc, make sure that /Qstrip_reflect option is *not* specified.
    ///        HLSL shaders need to be compiled against 4.0 profile or higher.
    const(void)* ByteCode = null;

    /// Size of the compiled shader bytecode

    /// Byte code size (in bytes) must be provided if ByteCode is not null
    size_t ByteCodeSize = 0;

    /// Shader entry point

    /// This member is ignored if ByteCode is not null
    const(char)* EntryPoint = "main";

    /// Shader macros

    /// This member is ignored if ByteCode is not null
    const ShaderMacro* Macros = null;

    /// If set to true, textures will be combined with texture samplers.
    /// The CombinedSamplerSuffix member defines the suffix added to the texture variable
    /// name to get corresponding sampler name. When using combined samplers,
    /// the sampler assigned to the shader resource view is automatically set when
    /// the view is bound. Otherwise samplers need to be explicitly set similar to other
    /// shader variables.
    /// This member has no effect if the shader is used in the PSO that uses pipeline resource signature(s).
    bool UseCombinedTextureSamplers = false;

    /// If UseCombinedTextureSamplers is true, defines the suffix added to the
    /// texture variable name to get corresponding sampler name.  For example,
    /// for default value "_sampler", a texture named "tex" will be combined
    /// with sampler named "tex_sampler".
    /// If UseCombinedTextureSamplers is false, this member is ignored.
    /// This member has no effect if the shader is used in the PSO that uses pipeline resource signature(s).
    const(char)* CombinedSamplerSuffix = "_sampler";

    /// Shader description. See Diligent::ShaderDesc.
    ShaderDesc Desc;

    /// Shader source language. See Diligent::SHADER_SOURCE_LANGUAGE.
    SHADER_SOURCE_LANGUAGE SourceLanguage = SHADER_SOURCE_LANGUAGE.SHADER_SOURCE_LANGUAGE_DEFAULT;

    /// Shader compiler. See Diligent::SHADER_COMPILER.
    SHADER_COMPILER ShaderCompiler = SHADER_COMPILER.SHADER_COMPILER_DEFAULT;

    /// HLSL shader model to use when compiling the shader. When default value
    /// is given (0, 0), the engine will attempt to use the highest HLSL shader model
    /// supported by the device. If the shader is created from the byte code, this value
    /// has no effect.
    ///
    /// \note When HLSL source is converted to GLSL, corresponding GLSL/GLESSL version will be used.
    ShaderVersion HLSLVersion = {};

    /// GLSL version to use when creating the shader. When default value
    /// is given (0, 0), the engine will attempt to use the highest GLSL version
    /// supported by the device.
    ShaderVersion GLSLVersion = {};;

    /// GLES shading language version to use when creating the shader. When default value
    /// is given (0, 0), the engine will attempt to use the highest GLESSL version
    /// supported by the device.
    ShaderVersion GLESSLVersion = {};

    /// Shader compile flags (see Diligent::SHADER_COMPILE_FLAGS).
    SHADER_COMPILE_FLAGS CompileFlags = SHADER_COMPILE_FLAGS.SHADER_COMPILE_FLAG_NONE;

    /// Memory address where pointer to the compiler messages data blob will be written

    /// The buffer contains two null-terminated strings. The first one is the compiler
    /// output message. The second one is the full shader source code including definitions added
    /// by the engine. Data blob object must be released by the client.
    IDataBlob** ppCompilerOutput = null;
}

/// Describes shader resource type
enum SHADER_RESOURCE_TYPE : ubyte
{
    /// Shader resource type is unknown
    SHADER_RESOURCE_TYPE_UNKNOWN = 0,

    /// Constant (uniform) buffer
    SHADER_RESOURCE_TYPE_CONSTANT_BUFFER,

    /// Shader resource view of a texture (sampled image)
    SHADER_RESOURCE_TYPE_TEXTURE_SRV,

    /// Shader resource view of a buffer (read-only storage image)
    SHADER_RESOURCE_TYPE_BUFFER_SRV,

    /// Unordered access view of a texture (storage image)
    SHADER_RESOURCE_TYPE_TEXTURE_UAV,

    /// Unordered access view of a buffer (storage buffer)
    SHADER_RESOURCE_TYPE_BUFFER_UAV,

    /// Sampler (separate sampler)
    SHADER_RESOURCE_TYPE_SAMPLER,

    /// Input attachment in a render pass
    SHADER_RESOURCE_TYPE_INPUT_ATTACHMENT,

    /// Acceleration structure
    SHADER_RESOURCE_TYPE_ACCEL_STRUCT,

    SHADER_RESOURCE_TYPE_LAST = SHADER_RESOURCE_TYPE_ACCEL_STRUCT
}

/// Shader resource description
struct ShaderResourceDesc
{
    /// Shader resource name
    const(char)* Name = null;

    /// Shader resource type, see Diligent::SHADER_RESOURCE_TYPE.
    SHADER_RESOURCE_TYPE Type = SHADER_RESOURCE_TYPE.SHADER_RESOURCE_TYPE_UNKNOWN;

    /// Array size. For non-array resource this value is 1.
    uint ArraySize = 0;
}

/// Shader interface
struct IShaderMethods
{
    /// Returns the total number of shader resources
    uint* GetResourceCount(IShader*);

    /// Returns the pointer to the array of shader resources
    void* GetResourceDesc(IShader*, uint Index, ShaderResourceDesc* ResourceDesc);
}

struct IShaderVtbl { IShaderMethods Shader; }
struct IShader { IShaderVtbl* pVtbl; }

ShaderDesc* IShader_GetDesc(IShader* object) {
    cast(const(ShaderDesc)*)IDeviceObject_GetDesc(object);
}

uint* IShader_GetResourceCount(IShader* shader) {
    return shader.pVtbl.Shader.GetResourceCount(shader);
}

void* IShader_GetResourceDesc(IShader* shader, uint index, ShaderResourceDesc* resourceDesc) {
    return shader.pVtbl.Shader.GetResourceDesc(shader, index, resourceDesc);
}