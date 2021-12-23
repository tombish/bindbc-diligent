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

module bindbc.diligent.graphics.opengl.enginefactoryopengl;

/// \file
/// Declaration of functions that create OpenGL-based engine implementation

import bindbc.diligent.graphics.enginefactory;
import bindbc.diligent.graphics.renderdevice;
import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.swapchain;

import bindbc.diligent.graphics.hlsl2glslconverterlib.hlsl2glslconverter;

version(BindDiligent_Dynamic) { version(Windows) {
    import bindbc.diligent.graphics.loadenginedll;
    enum EXPLICITLY_LOAD_ENGINE_GL_DLL = 1;
} else { enum EXPLICITLY_LOAD_ENGINE_GL_DLL = 0; }}

// {9BAAC767-02CC-4FFA-9E4B-E1340F572C49}
static const INTERFACE_ID IID_EngineFactoryOpenGL =
    INTERFACE_ID(0x9baac767, 0x2cc, 0x4ffa, [0x9e, 0x4b, 0xe1, 0x34, 0xf, 0x57, 0x2c, 0x49]);

struct IEngineFactoryOpenGLMethods
{
    void* CreateDeviceAndSwapChainGL(IEngineFactoryOpenGL*,
                                                    const(EngineGLCreateInfo)* EngineCI,
                                                    IRenderDevice**            ppDevice,
                                                    IDeviceContext**           ppImmediateContext,
                                                    const(SwapChainDesc)*      SCDesc,
                                                    ISwapChain**               ppSwapChain);

    void* CreateHLSL2GLSLConverter(IEngineFactoryOpenGL*, IHLSL2GLSLConverter** ppConverter);

    void* AttachToActiveGLContext(IEngineFactoryOpenGL*,
                                                const(EngineGLCreateInfo)* EngineCI,
                                                IRenderDevice**            ppDevice,
                                                IDeviceContext**           ppImmediateContext);
}

struct IEngineFactoryOpenGLVtbl { IEngineFactoryOpenGLMethods EngineFactoryOpenGL; }
struct IEngineFactoryOpenGL { IEngineFactoryOpenGLVtbl* pVtbl; }

void* IEngineFactoryOpenGL_CreateDeviceAndSwapChainGL(IEngineFactoryOpenGL* factory,
                                                    const(EngineGLCreateInfo)* engineCI,
                                                    IRenderDevice**            ppDevice,
                                                    IDeviceContext**           ppImmediateContext,
                                                    const(SwapChainDesc)*      scDesc,
                                                    ISwapChain**               ppSwapChain) {
    return factory.pVtbl.EngineFactoryOpenGL.CreateDeviceAndSwapChainGL(factory, engineCI, ppDevice, ppImmediateContext, scDesc, ppSwapChain);
}

void* IEngineFactoryOpenGL_CreateHLSL2GLSLConverter(IEngineFactoryOpenGL* factory, IHLSL2GLSLConverter** ppConverter) {
    return factory.pVtbl.EngineFactoryOpenGL.CreateHLSL2GLSLConverter(factory, ppConverter);
}

void* IEngineFactoryOpenGL_AttachToActiveGLContext(IEngineFactoryOpenGL* factory,
                                                const(EngineGLCreateInfo)* engineCI,
                                                IRenderDevice**            ppDevice,
                                                IDeviceContext**           ppImmediateContext) {
    return factory.pVtbl.EngineFactoryOpenGL.AttachToActiveGLContext(factory, engineCI, ppDevice, ppImmediateContext);
}

version(BindDiligent_Dynamic) {
    static if (EXPLICITLY_LOAD_ENGINE_GL_DLL) {
        IEngineFactoryOpenGL* function() GetEngineFactoryOpenGLType;

        GetEngineFactoryOpenGLType Diligent_LoadGraphicsEngineOpenGL()
        {
            return cast(GetEngineFactoryOpenGLType)LoadEngineDll("GraphicsEngineOpenGL", "GetEngineFactoryOpenGL");
        } 
    } else {    
        // Do not forget to call System.loadLibrary("GraphicsEngineOpenGL") in Java on Android!
        IEngineFactoryOpenGL* Diliget_GetEngineFactoryOpenGL();
    }
}
