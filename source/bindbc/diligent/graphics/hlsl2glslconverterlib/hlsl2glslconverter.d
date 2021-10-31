/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
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

module bindbc.diligent.graphics.hlsl2glslconverterlib.hlsl2glslconverter;

/// \file
/// Definition of the Diligent::IHLSL2GLSLConverter interface

import bindbc.diligent.graphics.shader;
import bindbc.diligent.primitives.datablob;

// {1FDE020A-9C73-4A76-8AEF-C2C6C2CF0EA5}
static const INTERFACE_ID IID_HLSL2GLSLConversionStream =
    INTERFACE_ID(0x1fde020a, 0x9c73, 0x4a76, [0x8a, 0xef, 0xc2, 0xc6, 0xc2, 0xcf, 0xe, 0xa5]);

struct IHLSL2GLSLConversionStreamMethods
{
    extern(C) @nogc nothrow {
        void* Convert(IHLSL2GLSLConversionStream*,
                                    const(char)* EntryPoint,
                                    SHADER_TYPE ShaderType,
                                    bool        IncludeDefintions,
                                    const(char)* SamplerSuffix,
                                    bool        UseInOutLocationQualifiers,
                                    IDataBlob** ppGLSLSource);
    }
}

struct IHLSL2GLSLConversionStreamVtbl { IHLSL2GLSLConversionStreamMethods HLSL2GLSLConversionStream; }
struct IHLSL2GLSLConversionStream { IHLSL2GLSLConversionStreamVtbl* pVtbl; }

//#    define IHLSL2GLSLConversionStream_Convert(This, ...) CALL_IFACE_METHOD(HLSL2GLSLConversionStream, Convert, This, __VA_ARGS__)

void* IHLSL2GLSLConversionStream_Convert(IHLSL2GLSLConversionStream* convert,
                                            const(char)* entryPoint,
                                            SHADER_TYPE shaderType,
                                            bool        includeDefintions,
                                            const(char)* samplerSuffix,
                                            bool        useInOutLocationQualifiers,
                                            IDataBlob** ppGLSLSource) {
    return convert.pVtbl.HLSL2GLSLConversionStream.Convert(convert, entryPoint, shaderType, includeDefintions, samplerSuffix, useInOutLocationQualifiers, ppGLSLSource);
}
// {44A21160-77E0-4DDC-A57E-B8B8B65B5342}
static const INTERFACE_ID IID_HLSL2GLSLConverter =
    INTERFACE_ID(0x44a21160, 0x77e0, 0x4ddc, [0xa5, 0x7e, 0xb8, 0xb8, 0xb6, 0x5b, 0x53, 0x42]);

/// Interface to the buffer object implemented in OpenGL
struct IObjectInclusiveMethods
{
    extern(C) @nogc nothrow {
        void* CreateStream(IHLSL2GLSLConverter*,
                                        const(char)*                      inputFileName,
                                        IShaderSourceInputStreamFactory*  pSourceStreamFactory,
                                        const(char)*                      hlslSource,
                                        size_t                            numSymbols,
                                        IHLSL2GLSLConversionStream**      ppStream);
    }
}

struct IHLSL2GLSLConverterVtbl { IHLSL2GLSLConverterMethods HLSL2GLSLConverter; }
struct IHLSL2GLSLConverter { IHLSL2GLSLConverterVtbl* pVtbl; }

void* IHLSL2GLSLConverter_CreateStream(IHLSL2GLSLConverter* converter,
                                      const(char)*                      inputFileName,
                                      IShaderSourceInputStreamFactory*  pSourceStreamFactory,
                                      const(char)*                      hlslSource,
                                      size_t                            numSymbols,
                                      IHLSL2GLSLConversionStream**      ppStream) {
    return converter.pVtbl.HLSL2GLSLConverter.CreateStream(converter, inputFileName, pSourceStreamFactory, hlslSource, numSymbols, ppStream);
}